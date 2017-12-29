{ stdenv, fetchurl, fetchpatch, lib
, ncurses, openssl, aspell, gnutls
, zlib, curl, pkgconfig, libgcrypt
, cmake, makeWrapper, libobjc, libresolv, libiconv
, writeScriptBin, symlinkJoin # for withPlugins
, asciidoctor # manpages
, guileSupport ? true, guile
, luaSupport ? true, lua5
, perlSupport ? true, perl
, pythonSupport ? true, pythonPackages
, rubySupport ? true, ruby
, tclSupport ? true, tcl
, extraBuildInputs ? []
, configure ? null
, runCommand }:

let
  inherit (pythonPackages) python pycrypto pync;
  plugins = [
    { name = "perl"; enabled = perlSupport; cmakeFlag = "ENABLE_PERL"; buildInputs = [ perl ]; }
    { name = "tcl"; enabled = tclSupport; cmakeFlag = "ENABLE_TCL"; buildInputs = [ tcl ]; }
    { name = "ruby"; enabled = rubySupport; cmakeFlag = "ENABLE_RUBY"; buildInputs = [ ruby ]; }
    { name = "guile"; enabled = guileSupport; cmakeFlag = "ENABLE_GUILE"; buildInputs = [ guile ]; }
    { name = "lua"; enabled = luaSupport; cmakeFlag = "ENABLE_LUA"; buildInputs = [ lua5 ]; }
    { name = "python"; enabled = pythonSupport; cmakeFlag = "ENABLE_PYTHON"; buildInputs = [ python ]; }
  ];
  enabledPlugins = builtins.filter (p: p.enabled) plugins;

  weechat =
    assert lib.all (p: p.enabled -> ! (builtins.elem null p.buildInputs)) plugins;
    stdenv.mkDerivation rec {
      version = "1.9.1";
      name = "weechat-${version}";

      src = fetchurl {
        url = "http://weechat.org/files/src/weechat-${version}.tar.bz2";
        sha256 = "1kgi079bq4n0wb7hc7mz8p7ay1b2m0a4wpvb92sfsxrnh10qr5m1";
      };

      patches = [
        # TODO: Remove this patch when weechat is updated to a release that
        # incorporates weechat/weechat#971
        (fetchpatch {
          url = https://github.com/lheckemann/weechat/commit/45a4f0565cc745b9c6e943f20199015185696df0.patch;
          sha256 = "0x7vv7g0k3b2hj444x2cinyv1mq5bkr6m18grfnyy6swbymzc9bj";
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
        license = stdenv.lib.licenses.gpl3;
        maintainers = with stdenv.lib.maintainers; [ lovek323 garbas the-kenny lheckemann ];
        platforms = stdenv.lib.platforms.unix;
      };
    };
in if configure == null then weechat else
  let
    perlInterpreter = perl;
    config = configure {
      availablePlugins = let
          simplePlugin = name: {pluginFile = "${weechat.${name}}/lib/weechat/plugins/${name}.so";};
        in rec {
          python = {
            pluginFile = "${weechat.python}/lib/weechat/plugins/python.so";
            withPackages = pkgsFun: (python // {
              extraEnv = ''
                export PYTHONHOME="${pythonPackages.python.withPackages pkgsFun}"
              '';
            });
          };
          perl = (simplePlugin "perl") // {
            extraEnv = ''
              export PATH="${perlInterpreter}/bin:$PATH"
            '';
          };
          tcl = simplePlugin "tcl";
          ruby = simplePlugin "ruby";
          guile = simplePlugin "guile";
          lua = simplePlugin "lua";
        };
      };

    inherit (config) plugins;

    pluginsDir = runCommand "weechat-plugins" {} ''
      mkdir -p $out/plugins
      for plugin in ${lib.concatMapStringsSep " " (p: p.pluginFile) plugins} ; do
        ln -s $plugin $out/plugins
      done
    '';
  in writeScriptBin "weechat" ''
    #!${stdenv.shell}
    export WEECHAT_EXTRA_LIBDIR=${pluginsDir}
    ${lib.concatMapStringsSep "\n" (p: lib.optionalString (p ? extraEnv) p.extraEnv) plugins}
    exec ${weechat}/bin/weechat "$@"
  ''
