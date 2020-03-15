{ pkgs, lib }:

with lib;
rec {
  # Base implementation for non-compiled executables.
  # Takes an interpreter, for example `${pkgs.bash}/bin/bash`
  #
  # Examples:
  #   writeBash = makeScriptWriter { interpreter = "${pkgs.bash}/bin/bash"; }
  #   makeScriptWriter { interpreter = "${pkgs.dash}/bin/dash"; } "hello" "echo hello world"
  makeScriptWriter = { interpreter, check ? "" }: nameOrPath: content:
    assert lib.or (types.path.check nameOrPath) (builtins.match "([0-9A-Za-z._])[0-9A-Za-z._-]*" nameOrPath != null);
    assert lib.or (types.path.check content) (types.str.check content);
    let
      name = last (builtins.split "/" nameOrPath);
    in

    pkgs.runCommandLocal name (if (types.str.check content) then {
      inherit content interpreter;
      passAsFile = [ "content" ];
    } else {
      inherit interpreter;
      contentPath = content;
    }) ''
      echo "#! $interpreter" > $out
      cat "$contentPath" >> $out
      ${optionalString (check != "") ''
        ${check} $out
      ''}
      chmod +x $out
      ${optionalString (types.path.check nameOrPath) ''
        mv $out tmp
        mkdir -p $out/$(dirname "${nameOrPath}")
        mv tmp $out/${nameOrPath}
      ''}
    '';

  # Base implementation for compiled executables.
  # Takes a compile script, which in turn takes the name as an argument.
  #
  # Examples:
  #   writeSimpleC = makeBinWriter { compileScript = name: "gcc -o $out $contentPath"; }
  makeBinWriter = { compileScript }: nameOrPath: content:
    assert lib.or (types.path.check nameOrPath) (builtins.match "([0-9A-Za-z._])[0-9A-Za-z._-]*" nameOrPath != null);
    assert lib.or (types.path.check content) (types.str.check content);
    let
      name = last (builtins.split "/" nameOrPath);
    in
    pkgs.runCommand name (if (types.str.check content) then {
      inherit content;
      passAsFile = [ "content" ];
    } else {
      contentPath = content;
    }) ''
      ${compileScript}
      ${optionalString (types.path.check nameOrPath) ''
        mv $out tmp
        mkdir -p $out/$(dirname "${nameOrPath}")
        mv tmp $out/${nameOrPath}
      ''}
    '';

  # Like writeScript but the first line is a shebang to bash
  #
  # Example:
  #   writeBash "example" ''
  #     echo hello world
  #   ''
  writeBash = makeScriptWriter {
    interpreter = "${pkgs.bash}/bin/bash";
  };

  # Like writeScriptBIn but the first line is a shebang to bash
  writeBashBin = name:
    writeBash "/bin/${name}";

  # writeC writes an executable c package called `name` to `destination` using `libraries`.
  #
  #  Examples:
  #    writeC "hello-world-ncurses" { libraries = [ pkgs.ncurses ]; } ''
  #      #include <ncurses.h>
  #      int main() {
  #        initscr();
  #        printw("Hello World !!!");
  #        refresh(); endwin();
  #        return 0;
  #      }
  #    ''
  writeC = name: { libraries ? [] }:
    makeBinWriter {
      compileScript = ''
        PATH=${makeBinPath [
          pkgs.binutils-unwrapped
          pkgs.coreutils
          pkgs.findutils
          pkgs.gcc
          pkgs.pkgconfig
        ]}
        export PKG_CONFIG_PATH=${concatMapStringsSep ":" (pkg: "${pkg}/lib/pkgconfig") libraries}
        gcc \
            ${optionalString (libraries != [])
              "$(pkg-config --cflags --libs ${
                concatMapStringsSep " " (pkg: "$(find ${escapeShellArg pkg}/lib/pkgconfig -name \\*.pc)") libraries
              })"
            } \
            -O \
            -o "$out" \
            -Wall \
            -x c \
            "$contentPath"
        strip --strip-unneeded "$out"
      '';
    } name;

  # writeCBin takes the same arguments as writeC but outputs a directory (like writeScriptBin)
  writeCBin = name:
    writeC "/bin/${name}";

  # Like writeScript but the first line is a shebang to dash
  #
  # Example:
  #   writeDash "example" ''
  #     echo hello world
  #   ''
  writeDash = makeScriptWriter {
    interpreter = "${pkgs.dash}/bin/dash";
  };

  # Like writeScriptBin but the first line is a shebang to dash
  writeDashBin = name:
    writeDash "/bin/${name}";

  # writeHaskell takes a name, an attrset with libraries and haskell version (both optional)
  # and some haskell source code and returns an executable.
  #
  # Example:
  #   writeHaskell "missiles" { libraries = [ pkgs.haskellPackages.acme-missiles ]; } ''
  #     import Acme.Missiles
  #
  #     main = launchMissiles
  #   '';
  writeHaskell = name: {
    libraries ? [],
    ghc ? pkgs.ghc
  }:
    makeBinWriter {
      compileScript = ''
        cp $contentPath tmp.hs
        ${ghc.withPackages (_: libraries )}/bin/ghc tmp.hs
        mv tmp $out
        ${pkgs.binutils-unwrapped}/bin/strip --strip-unneeded "$out"
      '';
    } name;

  # writeHaskellBin takes the same arguments as writeHaskell but outputs a directory (like writeScriptBin)
  writeHaskellBin = name:
    writeHaskell "/bin/${name}";

  # writeJS takes a name an attributeset with libraries and some JavaScript sourcecode and
  # returns an executable
  #
  # Example:
  #   writeJS "example" { libraries = [ pkgs.nodePackages.uglify-js ]; } ''
  #     var UglifyJS = require("uglify-js");
  #     var code = "function add(first, second) { return first + second; }";
  #     var result = UglifyJS.minify(code);
  #     console.log(result.code);
  #   ''
  writeJS = name: { libraries ? [] }: content:
  let
    node-env = pkgs.buildEnv {
      name = "node";
      paths = libraries;
      pathsToLink = [
        "/lib/node_modules"
      ];
    };
  in writeDash name ''
    export NODE_PATH=${node-env}/lib/node_modules
    exec ${pkgs.nodejs}/bin/node ${pkgs.writeText "js" content}
  '';

  # writeJSBin takes the same arguments as writeJS but outputs a directory (like writeScriptBin)
  writeJSBin = name:
    writeJS "/bin/${name}";

  awkFormatNginx = builtins.toFile "awkFormat-nginx.awk" ''
    awk -f
    {sub(/^[ \t]+/,"");idx=0}
    /\{/{ctx++;idx=1}
    /\}/{ctx--}
    {id="";for(i=idx;i<ctx;i++)id=sprintf("%s%s", id, "\t");printf "%s%s\n", id, $0}
   '';

  writeNginxConfig = name: text: pkgs.runCommandLocal name {
    inherit text;
    passAsFile = [ "text" ];
  } /* sh */ ''
    # nginx-config-formatter has an error - https://github.com/1connect/nginx-config-formatter/issues/16
    ${pkgs.gawk}/bin/awk -f ${awkFormatNginx} "$textPath" | ${pkgs.gnused}/bin/sed '/^\s*$/d' > $out
    ${pkgs.gixy}/bin/gixy $out
  '';

  # writePerl takes a name an attributeset with libraries and some perl sourcecode and
  # returns an executable
  #
  # Example:
  #   writePerl "example" { libraries = [ pkgs.perlPackages.boolean ]; } ''
  #     use boolean;
  #     print "Howdy!\n" if true;
  #   ''
  writePerl = name: { libraries ? [] }:
  let
    perl-env = pkgs.buildEnv {
      name = "perl-environment";
      paths = libraries;
      pathsToLink = [
        "/${pkgs.perl.libPrefix}"
      ];
    };
  in
  makeScriptWriter {
    interpreter = "${pkgs.perl}/bin/perl -I ${perl-env}/${pkgs.perl.libPrefix}";
  } name;

  # writePerlBin takes the same arguments as writePerl but outputs a directory (like writeScriptBin)
  writePerlBin = name:
    writePerl "/bin/${name}";

  # writePython2 takes a name an attributeset with libraries and some python2 sourcecode and
  # returns an executable
  #
  # Example:
  # writePython2 "test_python2" { libraries = [ pkgs.python2Packages.enum ]; } ''
  #   from enum import Enum
  #
  #   class Test(Enum):
  #       a = "success"
  #
  #   print Test.a
  # ''
  writePython2 = name: { libraries ? [], flakeIgnore ? [] }:
  let
    py = pkgs.python2.withPackages (ps: libraries);
    ignoreAttribute = optionalString (flakeIgnore != []) "--ignore ${concatMapStringsSep "," escapeShellArg flakeIgnore}";
  in
  makeScriptWriter {
    interpreter = "${py}/bin/python";
    check = writeDash "python2check.sh" ''
      exec ${pkgs.python2Packages.flake8}/bin/flake8 --show-source ${ignoreAttribute} "$1"
    '';
  } name;

  # writePython2Bin takes the same arguments as writePython2 but outputs a directory (like writeScriptBin)
  writePython2Bin = name:
    writePython2 "/bin/${name}";

  # writePython3 takes a name an attributeset with libraries and some python3 sourcecode and
  # returns an executable
  #
  # Example:
  # writePython3 "test_python3" { libraries = [ pkgs.python3Packages.pyyaml ]; } ''
  #   import yaml
  #
  #   y = yaml.load("""
  #     - test: success
  #   """)
  #   print(y[0]['test'])
  # ''
  writePython3 = name: { libraries ? [], flakeIgnore ? [] }:
  let
    py = pkgs.python3.withPackages (ps: libraries);
    ignoreAttribute = optionalString (flakeIgnore != []) "--ignore ${concatMapStringsSep "," escapeShellArg flakeIgnore}";
  in
  makeScriptWriter {
    interpreter = "${py}/bin/python";
    check = writeDash "python3check.sh" ''
      exec ${pkgs.python3Packages.flake8}/bin/flake8 --show-source ${ignoreAttribute} "$1"
    '';
  } name;

  # writePython3Bin takes the same arguments as writePython3 but outputs a directory (like writeScriptBin)
  writePython3Bin = name:
    writePython3 "/bin/${name}";
}
