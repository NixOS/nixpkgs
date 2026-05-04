{
  lib,
  stdenv,
  testers,
  cmake,
}:
lib.makeExtensible (
  final:
  lib.recurseIntoAttrs {
    cmakeFlags-structured = stdenv.mkDerivation (finalAttrs: {
      name = "test-cmakeFlags-structured";

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
        cmake
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
      canonicalCMakeEntries = finalAttrs.cmakeEntries // finalAttrs.canonicalCMakeEntriesBoolAttrs;

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

        for _key in "''${!canonicalCMakeEntries[@]}"; do
          if [[ "''${cmakeEntries[$_key]}" != "''${canonicalCMakeEntries[$_key]}" ]]; then
            echo "ERROR: $name: Expect cmakeEntries[$_key] to be ''${canonicalCMakeEntries[$_key]}, got ''${cmakeEntries[$_key]}" >&2
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

    cmakeFlags-structured-null = testers.testBuildFailure (
      final.cmakeFlags-structured.overrideAttrs (
        finalAttrs: previousAttrs: {
          name = "test-cmakeFlags-structured-null";
          cmakeEntries = previousAttrs.cmakeEntries or { } // {
            EXAMPLE_NULL = null;
          };
        }
      )
    );

    cmakeFlags-structured-list = testers.testBuildFailure (
      final.cmakeFlags-structured.overrideAttrs (
        finalAttrs: previousAttrs: {
          name = "test-cmakeFlags-structured-list";
          cmakeEntries = previousAttrs.cmakeEntries or { } // {
            EXAMPLE_LIST = [ ];
          };
        }
      )
    );

    cmakeFlags-structured-attrset = testers.testBuildFailure (
      final.cmakeFlags-structured.overrideAttrs (
        finalAttrs: previousAttrs: {
          name = "test-cmakeFlags-structured-attrset";
          cmakeEntries = previousAttrs.cmakeEntries or { } // {
            EXAMPLE_ATTRSET = { };
          };
        }
      )
    );

    cmakeFlags-structured-no-separateCMakeEntries = final.cmakeFlags-structured.overrideAttrs (
      finalAttrs: previousAttrs: {
        name = "test-cmakeFlags-structured-no-separateCMakeEntries";

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

    cmakeFlags-structured-separateCMakeEntries = final.cmakeFlags-structured.overrideAttrs (
      finalAttrs: previousAttrs: {
        name = "test-cmakeFlags-structured-separateCMakeEntries";

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

    cmakeFlags-unstructured = final.cmakeFlags-structured.overrideAttrs (
      finalAttrs: previousAttrs: {
        __structuredAttrs = false;
        name = "test-cmakeFlags-unstructured";

        expectedCMakeFlagsTypeFlag = "-x";

        cmakeEntries = null;
        canonicalCMakeEntries = null;
        canonicalCMakeEntriesBoolAttrs = null;

        preConfigure = previousAttrs.preConfigure or "" + ''
          ${
            (lib.replaceString "declare -A cmakeEntries=" "cmakeEntries+=" (
              lib.toShellVar "cmakeEntries" final.cmakeFlags-structured.cmakeEntries
            ))
          }
          ${lib.toShellVar "canonicalCMakeEntriesBoolAttrs" final.cmakeFlags-structured.canonicalCMakeEntriesBoolAttrs}
        '';
      }
    );

    cmakeFlags-unstructured-with-initial-cmakeFlags = final.cmakeFlags-unstructured.overrideAttrs (
      finalAttrs: previousAttrs: {
        name = "cmakeFlags-unstructured-with-initial-cmakeFlags";

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

    cmakeFlags-unstructured-with-initial-array = final.cmakeFlags-unstructured.overrideAttrs (
      finalAttrs: previousAttrs: {
        name = "cmakeFlags-unstructured-with-initial-array";

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
  }
)
