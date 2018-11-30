{ pkgs, lib }:

with lib;
rec {
  # Base implementation for non-compiled executables.
  # Takes an interpreter, for example `${pkgs.bash}/bin/bash`
  #
  # Examples:
  #   writeBash = makeScriptWriter { interpreter = "${pkgs.bash}/bin/bash"; }
  #   makeScriptWriter { interpreter = "${pkgs.dash}/bin/dash"; } "hello" "echo hello world"
  makeScriptWriter = { interpreter, check ? "" }: name: text:
    assert lib.or (types.path.check name) (builtins.match "([0-9A-Za-z._])[0-9A-Za-z._-]*" name != null);

    pkgs.writeTextFile {
      name = last (builtins.split "/" name);
      executable = true;
      destination = if types.path.check name then name else "";
      text = ''
        #! ${interpreter}
        ${text}
        '';
      checkPhase = check;
    };

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
  writeC = name: {
    libraries ? [],
  }: text: pkgs.runCommand name {
    inherit text;
    buildInputs = [ pkgs.pkgconfig ] ++ libraries;
    passAsFile = [ "text" ];
  } ''
    PATH=${makeBinPath [
      pkgs.binutils-unwrapped
      pkgs.coreutils
      pkgs.gcc
      pkgs.pkgconfig
    ]}
    mkdir -p "$(dirname "$out")"
    gcc \
        ${optionalString (libraries != [])
          "$(pkg-config --cflags --libs ${
            concatMapStringsSep " " (lib: escapeShellArg (builtins.parseDrvName lib.name).name) (libraries)
          })"
        } \
        -O \
        -o "$out" \
        -Wall \
        -x c \
        "$textPath"
    strip --strip-unneeded "$out"
  '';

  # writeCBin takes the same arguments as writeC but outputs a directory (like writeScriptBin)
  writeCBin = name: spec: text:
    pkgs.runCommand name {
    } ''
      mkdir -p $out/bin
      ln -s ${writeC name spec text} $out/bin/${name}
    '';

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
  #     Import Acme.Missiles
  #
  #     main = launchMissiles
  #   '';
  writeHaskell = name: {
    libraries ? [],
    ghc ? pkgs.ghc
  }: text: pkgs.runCommand name {
    inherit text;
    passAsFile = [ "text" ];
  } ''
    cp $textPath ${name}.hs
    ${ghc.withPackages (_: libraries )}/bin/ghc ${name}.hs
    cp ${name} $out
  '';

  # writeHaskellBin takes the same arguments as writeHaskell but outputs a directory (like writeScriptBin)
  writeHaskellBin = name: spec: text:
    pkgs.runCommand name {
    } ''
      mkdir -p $out/bin
      ln -s ${writeHaskell name spec text} $out/bin/${name}
    '';

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
  writeJS = name: { libraries ? [] }: text:
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
    exec ${pkgs.nodejs}/bin/node ${pkgs.writeText "js" text}
  '';

  # writeJSBin takes the same arguments as writeJS but outputs a directory (like writeScriptBin)
  writeJSBin = name:
    writeJS "/bin/${name}";

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
        "/lib/perl5/site_perl"
      ];
    };
  in
  makeScriptWriter {
    interpreter = "${pkgs.perl}/bin/perl -I ${perl-env}/lib/perl5/site_perl";
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
