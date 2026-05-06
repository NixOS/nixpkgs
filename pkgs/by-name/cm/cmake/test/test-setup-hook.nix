{
  lib,
  # For quick development testing, use
  # nix-build --no-out-link pkgs/by-name/cm/cmake/test/test-setup-hook.nix --arg pkgs "import <nixpkgs> { }" --arg lib "import <nixpkgs/lib>" cmakeFlags-structured-jq
  # or
  # nix build --no-link -L -f pkgs/by-name/cm/cmake/test/test-setup-hook.nix --arg pkgs "import <nixpkgs> { }" --arg lib "import <nixpkgs/lib>" cmakeFlags-structured-jq
  pkgs ? { },
  stdenv ? pkgs.stdenv,
  testers ? pkgs.testers,
  jq ? pkgs.jq,
}:
lib.makeExtensible (
  final:
  lib.recurseIntoAttrs {
    cmakeFlags-structured-no-jq = stdenv.mkDerivation (finalAttrs: {
      name = "test-cmakeFlags-structured-no-jq";

      __structuredAttrs = true;

      cmakeEntries = {
        EXAMPLE_STRING = "Alice";
        EXAMPLE_BOOL_TRUE = true;
        EXAMPLE_BOOL_FALSE = false;
        EXAMPLE_INT = 42;
      };

      expectedShareDocName = "cmake-project-mock";

      cmakeListsText = ''
        cmake_minimum_required(VERSION 3.15)
        project("${finalAttrs.expectedShareDocName}")
      '';

      nativeBuildInputs = [
        ../setup-hook.sh
      ];

      unpackPhase = ''
        runHook preUnpack
        printf "%s" "$cmakeListsText" > CMakeLists.txt
        runHook postUnpack
      '';

      dontExecuteCMake = true;

      buildPhase = ''
        runHook preBuild

        declare -p cmakeEntries >> cmakeFlags.sh
        declare -p cmakeFlags >> cmakeFlags.sh

        declare -a cmakeEntryFlags=()
        concatCMakeEntryFlagsTo cmakeEntryFlags cmakeEntries
        declare -p cmakeEntryFlags >> cmakeFlags.sh

        runHook postBuild
      '';

      doCheck = true;

      nativeCheckInputs = [
        ./helper.sh
      ];

      expectedCMakeFlagsTypeFlag = "-a";

      canonicalCMakeEntriesBoolAttrs = lib.mapAttrs (n: v: if v then "ON" else "OFF") (
        lib.filterAttrs (n: lib.isBool) finalAttrs.cmakeEntries
      );

      checkPhase = ''
        runHook preCheck

        parsedShareDocName="$(parseShareDocName)"
        if [[ "$parsedShareDocName" != "$expectedShareDocName" ]]; then
          echo "ERROR: $name: Expect parseShareDocName to get the string $expectedShareDocName, got $parsedShareDocName" >&2
          exit 1
        fi

        testDeclaredType cmakeEntries "-A"
        testDeclaredType cmakeFlags "$expectedCMakeFlagsTypeFlag"

        concatCMakeEntryFlagsTo cmakeEntryFlags cmakeEntries

        if (( ''${#cmakeEntries[@]} != ''${#cmakeEntryFlags[@]} )); then
          echo "ERROR: $name: Expect cmakeEntries to convert to ''${#cmakeEntries[@]} flags, got ''${#cmakeEntryFlags[@]}." >&2
          exit 1
        fi

        for _flag in "''${cmakeEntryFlags[@]}"; do
          if ! [[ "$_flag" =~ ^-D ]]; then
            echo "ERROR: $name: Expect every converted cmakeEntries flags to prefix with -D, got ''$_flag." >&2
          fi
        done

        for _key in "''${!canonicalCMakeEntriesBoolAttrs[@]}"; do
          _valCanonical=$(canonicalizeCMakeBool "''${cmakeEntries[$_key]}")
          if [[ "$_valCanonical" != "''${canonicalCMakeEntriesBoolAttrs[$_key]}" ]]; then
            echo "ERROR: $name: Expect the canonicalized boolean value of cmakeEntries[$_key] to be ''${canonicalCMakeEntriesBoolAttrs[$_key]}, got $_valCanonical" >&2
            echo "  The original value of cmakeEntries[$_key] is ''${cmakeEntries[$_key]}" >&2
            exit 1
          fi
        done

        runHook postCheck
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p "$out/bin"
        install cmakeFlags.sh "$out/bin"

        runHook postInstall
      '';
    });

    cmakeFlags-structured-jq = final.cmakeFlags-structured-no-jq.overrideAttrs (
      finalAttrs: previousAttrs: {
        name = "test-cmakeFlags-structured-jq";

        nativeBuildInputs = previousAttrs.nativeBuildInputs or [ ] ++ [
          jq
        ];

        canonicalCMakeEntries = finalAttrs.cmakeEntries // finalAttrs.canonicalCMakeEntriesBoolAttrs;

        postCheck = ''
          for _key in "''${!canonicalCMakeEntries[@]}"; do
            if [[ "''${cmakeEntries[$_key]}" != "''${canonicalCMakeEntries[$_key]}" ]]; then
              echo "ERROR: $name: Expect cmakeEntries[$_key] to be ''${canonicalCMakeEntries[$_key]}, got ''${cmakeEntries[$_key]}" >&2
              exit 1
            fi
          done
        '';
      }
    );

    cmakeFlags-structured-jq-null-cmakeEntries = testers.testBuildFailure (
      final.cmakeFlags-structured-jq.overrideAttrs (
        finalAttrs: previousAttrs: {
          cmakeEntries = previousAttrs.cmakeEntries or { } // {
            EXAMPLE_NULL = null;
          };
        }
      )
    );
  }
  // (
    let
      tests-no-jq = {
        cmakeFlags-structured-no-separateCMakeEntries-no-jq =
          final.cmakeFlags-structured-no-jq.overrideAttrs
            (
              finalAttrs: previousAttrs: {
                name = "test-cmakeFlags-structured-no-separateCMakeEntries-no-jq";

                separateCMakeEntries = false;

                postCheck = previousAttrs.postCheck or "" + ''
                  for _flag in "''${cmakeEntryFlags[@]}"; do
                    if ! containsArg "$_flag" "''${cmakeFlags[@]}"; then
                      echo "ERROR: $name: Expect cmakeFlags to contain all flags from cmakeEntries as separateCMakeEntries=$separateCMakeEntries, found $_flag missing." >&2
                      exit 1
                    fi
                  done
                '';
              }
            );

        cmakeFlags-structured-separateCMakeEntries-no-jq = final.cmakeFlags-structured-no-jq.overrideAttrs (
          finalAttrs: previousAttrs: {
            name = "test-cmakeFlags-structured-separateCMakeEntries-no-jq";

            separateCMakeEntries = true;

            postCheck = previousAttrs.postCheck or "" + ''
              for _flag in "''${cmakeEntryFlags[@]}"; do
                if containsArg "$_flag" "''${cmakeFlags[@]}"; then
                  echo "ERROR: $name: Expect cmakeEntries to separate from cmakeFlags as separateCMakeEntries=$separateCMakeEntries, found $_flag in cmakeFlags." >&2
                  exit 1
                fi
              done
            '';
          }
        );

        cmakeFlags-unstructured-no-jq = final.cmakeFlags-structured-no-jq.overrideAttrs (
          finalAttrs: previousAttrs: {
            __structuredAttrs = false;
            name = "test-cmakeFlags-unstructured-no-jq";

            expectedCMakeFlagsTypeFlag = "-x";

            cmakeEntries = null;
            canonicalCMakeEntriesBoolAttrs = null;

            preConfigure = previousAttrs.preConfigure or "" + ''
              ${
                (lib.replaceString "declare -A cmakeEntries=" "cmakeEntries+=" (
                  lib.toShellVar "cmakeEntries" final.cmakeFlags-structured-no-jq.cmakeEntries
                ))
              }
              ${lib.toShellVar "canonicalCMakeEntriesBoolAttrs" final.cmakeFlags-structured-no-jq.canonicalCMakeEntriesBoolAttrs}
            '';
          }
        );

        cmakeFlags-unstructured-with-initial-cmakeFlags-no-jq =
          final.cmakeFlags-unstructured-no-jq.overrideAttrs
            (
              finalAttrs: previousAttrs: {
                name = "cmakeFlags-unstructured-with-initial-cmakeFlags-no-jq";

                expectedCMakeFlagsTypeFlag = "-x";

                preConfigure = previousAttrs.preConfigure or "" + ''
                  declare -a initialCMakeFlags=(--foo --bar)
                  prependToVar cmakeFlags "''${initialCMakeFlags}"
                '';

                postCheck = previousAttrs.postCheck or "" + ''
                  declare -a _flagArray_cmakeFlags=()
                  concatTo _flagArray_cmakeFlags cmakeFlags
                  for _flag in "''${initialCMakeFlags[@]}"; do
                    if ! containsArg "$_flag" "''${cmakeFlags[@]}"; then
                      echo "ERROR: $name: $_flag in initialCMakeFlags missing in cmakeFlags after cmakeConfigurePhase." >&2
                      exit 1
                    fi
                  done
                '';
              }
            );

        cmakeFlags-unstructured-with-initial-array-no-jq =
          final.cmakeFlags-unstructured-no-jq.overrideAttrs
            (
              finalAttrs: previousAttrs: {
                name = "cmakeFlags-unstructured-with-initial-array-no-jq";

                expectedCMakeFlagsTypeFlag = "-ax";

                preConfigure = previousAttrs.preConfigure or "" + ''
                  declare -a initialCMakeFlags=(--foo --bar)
                  cmakeFlags=("''${initialCMakeFlags[@]}")
                '';

                postCheck = previousAttrs.postCheck or "" + ''
                  for _flag in "''${initialCMakeFlags[@]}"; do
                    if ! containsArg "$_flag" "''${cmakeFlags[@]}"; then
                      echo "ERROR: $name: $_flag in initialCMakeFlags missing in cmakeFlags after cmakeConfigurePhase." >&2
                      exit 1
                    fi
                  done
                '';
              }
            );
      };
    in
    tests-no-jq
    // (lib.mapAttrs' (name: value: {
      name = lib.replaceString "-no-jq" "-jq" name;
      value = value.overrideAttrs (previousAttrs: {
        name = lib.replaceString "-no-jq" "-jq" previousAttrs.name;
        nativeBuildInputs = previousAttrs.nativeBuildInputs or [ ] ++ [ jq ];
      });
    }) (lib.getAttrs (lib.attrNames tests-no-jq) final))
  )
)
