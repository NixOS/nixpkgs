{
  devShellTools,
  emptyFile,
  lib,
  stdenv,
  hello,
  writeText,
  runCommand, zlib,
}:
let
  inherit (lib)
    concatLines
    escapeShellArg
    isString
    mapAttrsToList
    ;
in
{
  # nix-build -A tests.devShellTools.valueToString
  valueToString =
    let inherit (devShellTools) valueToString; in

    stdenv.mkDerivation {
      name = "devShellTools-valueToString-built-tests";

      # Test inputs
      inherit emptyFile hello;
      one = 1;
      boolTrue = true;
      boolFalse = false;
      foo = "foo";
      list = [ 1 2 3 ];
      pathDefaultNix = ./default.nix;
      packages = [ hello emptyFile ];
      # TODO: nested lists

      buildCommand = ''
        touch $out
        ( set -x
          [[ "$one" = ${escapeShellArg (valueToString 1)} ]]
          [[ "$boolTrue" = ${escapeShellArg (valueToString true)} ]]
          [[ "$boolFalse" = ${escapeShellArg (valueToString false)} ]]
          [[ "$foo" = ${escapeShellArg (valueToString "foo")} ]]
          [[ "$hello" = ${escapeShellArg (valueToString hello)} ]]
          [[ "$list" = ${escapeShellArg (valueToString [ 1 2 3 ])} ]]
          [[ "$packages" = ${escapeShellArg (valueToString [ hello emptyFile ])} ]]
          [[ "$pathDefaultNix" = ${escapeShellArg (valueToString ./default.nix)} ]]
          [[ "$emptyFile" = ${escapeShellArg (valueToString emptyFile)} ]]
        ) >log 2>&1 || { cat log; exit 1; }
      '';
    };

  # nix-build -A tests.devShellTools.valueToString
  unstructuredDerivationInputEnv =
    let
      inherit (devShellTools) unstructuredDerivationInputEnv;

      drvAttrs = {
        one = 1;
        boolTrue = true;
        boolFalse = false;
        foo = "foo";
        list = [ 1 2 3 ];
        pathDefaultNix = ./default.nix;
        stringWithDep = "Exe: ${hello}/bin/hello";
        aPackageAttrSet = hello;
        anOutPath = hello.outPath;
        anAnAlternateOutput = zlib.dev;

        passAsFile = [ "bar" ];
        bar = ''
          bar
          ${writeText "qux" "yea"}
        '';
      };
      result = unstructuredDerivationInputEnv { inherit drvAttrs; };
    in
    assert result // { barPath = "<check later>"; } == {
      one = "1";
      boolTrue = "1";
      boolFalse = "";
      foo = "foo";
      list = "1 2 3";
      pathDefaultNix = "${./default.nix}";
      stringWithDep = "Exe: ${hello}/bin/hello";
      aPackageAttrSet = "${hello}";
      anOutPath = "${hello.outPath}";
      anAnAlternateOutput = "${zlib.dev}";

      passAsFile = "bar";
      barPath = "<check later>";
    };

    # Not runCommand, because it alters `passAsFile`
    stdenv.mkDerivation ({
      name = "devShellTools-unstructuredDerivationInputEnv-built-tests";

      exampleBarPathString =
        assert isString result.barPath;
        result.barPath;

      dontUnpack = true;
      dontBuild = true;
      dontFixup = true;
      doCheck = true;

      installPhase = "touch $out";

      checkPhase = ''
        checkAttr() {
          echo checking attribute $1...
          if [[ "$2" != "$3" ]]; then
            echo "expected: $3"
            echo "actual: $2"
            exit 1
          fi
        }
        ${
          concatLines
            (mapAttrsToList
              (name: value:
                "checkAttr ${name} \"\$${name}\" ${escapeShellArg value}"
              )
              (removeAttrs
                result
                [
                  # Nix puts it in workdir, which is not a concept for
                  # unstructuredDerivationInputEnv, so we have to put it in the
                  # store instead. This means the full path won't match.
                  "barPath"
                ])
            )
        }
        (
          set -x

          diff $exampleBarPathString $barPath

          # TODO nice to have, as `cp $barPath foo/` preserves the basename:
          #      this is usually a mistake, so not that big a deal perhaps
          # [[ "$(basename $exampleBarPathString)" = "$(basename $barPath)" ]]
        )

        touch $out
      '';
    } // drvAttrs);
}
