{ stdenv, fetchurl, lib
, ncurses, openssl, aspell, gnutls, gettext
, zlib, curl, pkg-config, libgcrypt
, cmake, makeWrapper, libobjc, libresolv, libiconv
, asciidoctor # manpages
, guileSupport ? true, guile
, luaSupport ? true, lua5
, perlSupport ? true, perl
, pythonSupport ? true, python3Packages
, rubySupport ? true, ruby
, tclSupport ? true, tcl
, extraBuildInputs ? []
, fetchpatch
}:

let
  inherit (python3Packages) python;
  plugins = [
    { name = "perl"; enabled = perlSupport; cmakeFlag = "ENABLE_PERL"; buildInputs = [ perl ]; }
    { name = "tcl"; enabled = tclSupport; cmakeFlag = "ENABLE_TCL"; buildInputs = [ tcl ]; }
    { name = "ruby"; enabled = rubySupport; cmakeFlag = "ENABLE_RUBY"; buildInputs = [ ruby ]; }
    { name = "guile"; enabled = guileSupport; cmakeFlag = "ENABLE_GUILE"; buildInputs = [ guile ]; }
    { name = "lua"; enabled = luaSupport; cmakeFlag = "ENABLE_LUA"; buildInputs = [ lua5 ]; }
    { name = "python"; enabled = pythonSupport; cmakeFlag = "ENABLE_PYTHON3"; buildInputs = [ python ]; }
  ];
  enabledPlugins = builtins.filter (p: p.enabled) plugins;

  in
    assert lib.all (p: p.enabled -> ! (builtins.elem null p.buildInputs)) plugins;
    stdenv.mkDerivation rec {
      version = "3.6";
      pname = "weechat";

      hardeningEnable = [ "pie" ];

      src = fetchurl {
        url = "https://weechat.org/files/src/weechat-${version}.tar.bz2";
        sha256 = "sha256-GkYN/Y4LQQr7GdSDu0ucXXM9wWPAqKD1txJXkOhJMDc=";
      };

      outputs = [ "out" "man" ] ++ map (p: p.name) enabledPlugins;

      cmakeFlags = with lib; [
        "-DENABLE_MAN=ON"
        "-DENABLE_DOC=OFF"         # TODO: Documentation fails to build, was deactivated to push through security update
        "-DENABLE_JAVASCRIPT=OFF"  # Requires v8 <= 3.24.3, https://github.com/weechat/weechat/issues/360
        "-DENABLE_PHP=OFF"
      ]
        ++ optionals stdenv.isDarwin ["-DICONV_LIBRARY=${libiconv}/lib/libiconv.dylib"]
        ++ map (p: "-D${p.cmakeFlag}=" + (lib.boolToCMakeString p.enabled)) plugins
        ;

      nativeBuildInputs = [ cmake pkg-config makeWrapper asciidoctor ];
      buildInputs = with lib; [
          ncurses openssl aspell gnutls gettext zlib curl
          libgcrypt ]
        ++ optionals stdenv.isDarwin [ libobjc libresolv ]
        ++ concatMap (p: p.buildInputs) enabledPlugins
        ++ extraBuildInputs;

      NIX_CFLAGS_COMPILE = "-I${python}/include/${python.libPrefix}"
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
        homepage = "http://www.weechat.org/";
        description = "A fast, light and extensible chat client";
        longDescription = ''
          You can find more documentation as to how to customize this package
          (eg. adding python modules for scripts that would require them, etc.)
          on https://nixos.org/nixpkgs/manual/#sec-weechat .
        '';
        license = lib.licenses.gpl3;
        maintainers = with lib.maintainers; [ lovek323 ];
        platforms = lib.platforms.unix;
      };
    }
