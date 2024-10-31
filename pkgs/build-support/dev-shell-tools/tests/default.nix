{
  devShellTools,
  emptyFile,
  lib,
  stdenv,
  hello,
  writeText,
  zlib,
  nixosTests,
}:
let
  inherit (lib)
    concatLines
    escapeShellArg
    isString
    mapAttrsToList
    ;
in
lib.recurseIntoAttrs {

  # nix-build -A tests.devShellTools.nixos
  nixos = nixosTests.docker-tools-nix-shell;

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
        args = [ "args must not be added to the environment" "Nix doesn't do it." ];

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
        fail() {
          echo "$@" >&2
          exit 1
        }
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
                  "args"

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

          ${lib.optionalString (builtins?convertHash) ''
            [[ "$(basename $exampleBarPathString)" = "$(basename $barPath)" ]]
          ''}
        )

        ''${args:+fail "args should not be set by Nix. We don't expect it to and unstructuredDerivationInputEnv removes it."}
        if [[ "''${builder:-x}" == x ]]; then
          fail "builder should be set by Nix. We don't remove it in unstructuredDerivationInputEnv."
        fi
      '';
    } // removeAttrs drvAttrs [
      # This would break the derivation. Instead, we have a check in the derivation to make sure Nix doesn't set it.
      "args"
    ]);
}
