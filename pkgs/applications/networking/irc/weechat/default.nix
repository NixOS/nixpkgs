{ stdenv, fetchurl, lib
, ncurses, openssl, aspell, gnutls
, zlib, curl, pkgconfig, libgcrypt
, cmake, makeWrapper, libobjc, libresolv, libiconv
, asciidoctor # manpages
, guileSupport ? true, guile
, luaSupport ? true, lua5
, perlSupport ? true, perl, perlPackages
, pythonSupport ? true, pythonPackages
, rubySupport ? true, ruby
, tclSupport ? true, tcl
, extraBuildInputs ? []
, fetchpatch
}:

let
  inherit (pythonPackages) python;
  plugins = [
    { name = "perl"; enabled = perlSupport; cmakeFlag = "ENABLE_PERL"; buildInputs = [ perl ]; }
    { name = "tcl"; enabled = tclSupport; cmakeFlag = "ENABLE_TCL"; buildInputs = [ tcl ]; }
    { name = "ruby"; enabled = rubySupport; cmakeFlag = "ENABLE_RUBY"; buildInputs = [ ruby ]; }
    { name = "guile"; enabled = guileSupport; cmakeFlag = "ENABLE_GUILE"; buildInputs = [ guile ]; }
    { name = "lua"; enabled = luaSupport; cmakeFlag = "ENABLE_LUA"; buildInputs = [ lua5 ]; }
    { name = "python"; enabled = pythonSupport; cmakeFlag = "ENABLE_PYTHON"; buildInputs = [ python ]; }
  ];
  enabledPlugins = builtins.filter (p: p.enabled) plugins;

  in
    assert lib.all (p: p.enabled -> ! (builtins.elem null p.buildInputs)) plugins;
    stdenv.mkDerivation rec {
      version = "2.4";
      name = "weechat-${version}";

      src = fetchurl {
        url = "https://weechat.org/files/src/weechat-${version}.tar.bz2";
        sha256 = "1z80y5fbrb56wdcx9njrf203r8282wnn3piw3yffk5lvhklsz9k1";
      };

      patches = [
        (fetchpatch {
          url = https://github.com/weechat/weechat/commit/6a9937f08ad2c14aeb0a847ffb99e652d47d8251.patch;
          sha256 = "1blhgxwqs65dvpw3ppxszxrsg02rx7qck1w71h61ljinyjzri3bp";
          excludes = [ "ChangeLog.adoc" ];
        })
      ];

      outputs = [ "out" "man" ] ++ map (p: p.name) enabledPlugins;

      enableParallelBuilding = true;
      cmakeFlags = with stdenv.lib; [
        "-DENABLE_MAN=ON"
        "-DENABLE_DOC=ON"
      ]
        ++ optionals stdenv.isDarwin ["-DICONV_LIBRARY=${libiconv}/lib/libiconv.dylib" "-DCMAKE_FIND_FRAMEWORK=LAST"]
        ++ map (p: "-D${p.cmakeFlag}=" + (if p.enabled then "ON" else "OFF")) plugins
        ;

      buildInputs = with stdenv.lib; [
          ncurses openssl aspell gnutls zlib curl pkgconfig
          libgcrypt makeWrapper cmake asciidoctor
          ]
        ++ optionals stdenv.isDarwin [ libobjc libresolv ]
        ++ concatMap (p: p.buildInputs) enabledPlugins
        ++ extraBuildInputs;

      NIX_CFLAGS_COMPILE = "-I${python}/include/${python.libPrefix}"
        # Fix '_res_9_init: undefined symbol' error
        + (stdenv.lib.optionalString stdenv.isDarwin "-DBIND_8_COMPAT=1 -lresolv");

      postInstall = with stdenv.lib; ''
        for p in ${concatMapStringsSep " " (p: p.name) enabledPlugins}; do
          from=$out/lib/weechat/plugins/$p.so
          to=''${!p}/lib/weechat/plugins/$p.so
          mkdir -p $(dirname $to)
          mv $from $to
        done
      '';

      meta = {
        homepage = http://www.weechat.org/;
        description = "A fast, light and extensible chat client";
        longDescription = ''
          You can find more documentation as to how to customize this package
          (eg. adding python modules for scripts that would require them, etc.)
          on https://nixos.org/nixpkgs/manual/#sec-weechat .
        '';
        license = stdenv.lib.licenses.gpl3;
        maintainers = with stdenv.lib.maintainers; [ lovek323 garbas the-kenny lheckemann ma27 ];
        platforms = stdenv.lib.platforms.unix;
      };
    }
