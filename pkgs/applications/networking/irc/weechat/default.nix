{ stdenv, fetchurl, lib
, ncurses, openssl, aspell, gnutls, gettext
, zlib, curl, pkg-config, libgcrypt
, cmake, libobjc, libresolv, libiconv
, asciidoctor # manpages
, enableTests ? !stdenv.isDarwin, cpputest
, guileSupport ? true, guile
, luaSupport ? true, lua5
, perlSupport ? true, perl
, pythonSupport ? true, python3Packages
, rubySupport ? true, ruby
, tclSupport ? true, tcl
, phpSupport ? !stdenv.isDarwin, php, systemd, libxml2, pcre2, libargon2
, extraBuildInputs ? []
}:

let
  inherit (python3Packages) python;
  php-embed = php.override {
    embedSupport = true;
    apxs2Support = false;
  };
  plugins = [
    { name = "perl"; enabled = perlSupport; cmakeFlag = "ENABLE_PERL"; buildInputs = [ perl ]; }
    { name = "tcl"; enabled = tclSupport; cmakeFlag = "ENABLE_TCL"; buildInputs = [ tcl ]; }
    { name = "ruby"; enabled = rubySupport; cmakeFlag = "ENABLE_RUBY"; buildInputs = [ ruby ]; }
    { name = "guile"; enabled = guileSupport; cmakeFlag = "ENABLE_GUILE"; buildInputs = [ guile ]; }
    { name = "lua"; enabled = luaSupport; cmakeFlag = "ENABLE_LUA"; buildInputs = [ lua5 ]; }
    { name = "python"; enabled = pythonSupport; cmakeFlag = "ENABLE_PYTHON3"; buildInputs = [ python ]; }
    { name = "php"; enabled = phpSupport; cmakeFlag = "ENABLE_PHP"; buildInputs = [
      php-embed.unwrapped.dev libxml2 pcre2 libargon2
    ] ++ lib.optional stdenv.isLinux systemd; }
  ];
  enabledPlugins = builtins.filter (p: p.enabled) plugins;

  in
    assert lib.all (p: p.enabled -> ! (builtins.elem null p.buildInputs)) plugins;
    stdenv.mkDerivation rec {
      version = "4.2.1";
      pname = "weechat";

      hardeningEnable = [ "pie" ];

      src = fetchurl {
        url = "https://weechat.org/files/src/weechat-${version}.tar.xz";
        hash = "sha256-JT3fCG9shFAxot0pSxVShR1rBMwIovnaSu37Pi+Rvc0=";
      };

      # Why is this needed? https://github.com/weechat/weechat/issues/2031
      patches = lib.optional gettext.gettextNeedsLdflags ./gettext-intl.patch;

      outputs = [ "out" "man" ] ++ map (p: p.name) enabledPlugins;

      cmakeFlags = with lib; [
        "-DENABLE_MAN=ON"
        "-DENABLE_DOC=ON"
        "-DENABLE_DOC_INCOMPLETE=ON"
        "-DENABLE_TESTS=${if enableTests then "ON" else "OFF"}"
      ]
        ++ optionals stdenv.isDarwin ["-DICONV_LIBRARY=${libiconv}/lib/libiconv.dylib"]
        ++ map (p: "-D${p.cmakeFlag}=" + (if p.enabled then "ON" else "OFF")) plugins
        ;

      nativeBuildInputs = [ cmake pkg-config asciidoctor ] ++ lib.optional enableTests cpputest;
      buildInputs = with lib; [
          ncurses openssl aspell gnutls gettext zlib curl
          libgcrypt ]
        ++ optionals stdenv.isDarwin [ libobjc libresolv ]
        ++ concatMap (p: p.buildInputs) enabledPlugins
        ++ extraBuildInputs;

      env.NIX_CFLAGS_COMPILE = "-I${python}/include/${python.libPrefix}"
        # Fix '_res_9_init: undefined symbol' error
        + (lib.optionalString stdenv.isDarwin "-DBIND_8_COMPAT=1 -lresolv");

      postInstall = with lib; ''
        for p in ${concatMapStringsSep " " (p: p.name) enabledPlugins}; do
          from=$out/lib/weechat/plugins/$p.so
          to=''${!p}/lib/weechat/plugins/$p.so
          mkdir -p $(dirname $to)
          mv $from $to
        done
      '';

      doInstallCheck = true;
      installCheckPhase = ''
        $out/bin/weechat --version
      '';

      meta = {
        homepage = "https://weechat.org/";
        changelog = "https://weechat.org/files/doc/weechat/ChangeLog-${version}.html";
        description = "Fast, light and extensible chat client";
        longDescription = ''
          You can find more documentation as to how to customize this package
          (e.g. adding python modules for scripts that would require them, etc.)
          on https://nixos.org/nixpkgs/manual/#sec-weechat .
        '';
        license = lib.licenses.gpl3;
        maintainers = with lib.maintainers; [ ncfavier ];
        mainProgram = "weechat";
        platforms = lib.platforms.unix;
      };
    }
