{ stdenv, fetchurl, lib
, ncurses, openssl, aspell, gnutls
, zlib, curl, pkgconfig, libgcrypt
, cmake, makeWrapper, libobjc, libresolv, libiconv
, writeScriptBin # for withPlugins
, asciidoctor # manpages
, guileSupport ? true, guile
, luaSupport ? true, lua5
, perlSupport ? true, perl
, pythonSupport ? true, pythonPackages
, rubySupport ? true, ruby
, tclSupport ? true, tcl
, extraBuildInputs ? []
, configure ? { availablePlugins, ... }: { plugins = builtins.attrValues availablePlugins; }
, runCommand, buildEnv
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

  weechat =
    assert lib.all (p: p.enabled -> ! (builtins.elem null p.buildInputs)) plugins;
    stdenv.mkDerivation rec {
      version = "2.2";
      name = "weechat-${version}";

      src = fetchurl {
        url = "http://weechat.org/files/src/weechat-${version}.tar.bz2";
        sha256 = "0p4nhh7f7w4q77g7jm9i6fynndqlgjkc9dk5g1xb4gf9imiisqlg";
      };

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

      # remove when bumping to the latest version.
      # This patch basically rebases `fcf7469d7664f37e94d5f6d0b3fe6fce6413f88c`
      # from weechat upstream to weechat-2.2.
      patches = [
        ./aggregate-commands.patch
      ];

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
    };
in if configure == null then weechat else
  let
    perlInterpreter = perl;
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

    config = configure { inherit availablePlugins; };

    plugins = config.plugins or (builtins.attrValues availablePlugins);

    pluginsDir = runCommand "weechat-plugins" {} ''
      mkdir -p $out/plugins
      for plugin in ${lib.concatMapStringsSep " " (p: p.pluginFile) plugins} ; do
        ln -s $plugin $out/plugins
      done
    '';

    init = let
      init = builtins.replaceStrings [ "\n" ] [ ";" ] (config.init or "");

      mkScript = drv: lib.flip map drv.scripts (script: "/script load ${drv}/share/${script}");

      scripts = builtins.concatStringsSep ";" (lib.foldl (scripts: drv: scripts ++ mkScript drv)
        [ ] (config.scripts or []));
    in "${scripts}\n${init}";

    mkWeechat = bin: (writeScriptBin bin ''
      #!${stdenv.shell}
      export WEECHAT_EXTRA_LIBDIR=${pluginsDir}
      ${lib.concatMapStringsSep "\n" (p: lib.optionalString (p ? extraEnv) p.extraEnv) plugins}
      exec ${weechat}/bin/${bin} "$@" --run-command "${init}"
    '') // {
      inherit (weechat) name meta;
      unwrapped = weechat;
    };
  in buildEnv {
    name = "weechat-bin-env";
    paths = [
      (mkWeechat "weechat")
      (mkWeechat "weechat-headless")
    ];
  }
