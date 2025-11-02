/**
  Tests that depend on a Python interpreter.

  To run these tests:

    [nixpkgs]$ nix-build lib/tests/python

  If the build finishes successfully, all tests passed.
  Alternatively, to run all `lib` tests:

    [nixpkgs]$ nix-build lib/tests/release.nix
*/
{
  pkgs ? import ../../.. { },
  lib ? pkgs.lib,
}:
let
  allBytesExceptNullPath = ./all-bytes-except-null.bin;
  allBytesExceptNullData = lib.strings.readFile allBytesExceptNullPath;
  emptyFilePath = ./empty-file.bin;
  emptyFileData = lib.strings.readFile emptyFilePath;
  textFilePath = ./default.nix;
  textFileData = lib.strings.readFile textFilePath;

  pythonTestScript = pkgs.writers.writePython3Bin "reproduce-test-data-using-escapePythonBytes" { } ''
    import pathlib

    pathlib.Path("all-bytes-except-null-reproduction.bin").write_bytes(
        ${lib.strings.escapePythonBytes allBytesExceptNullData}  # noqa: E501
    )
    pathlib.Path("empty-file-reproduction.bin").write_bytes(
        ${lib.strings.escapePythonBytes emptyFileData}
    )
    pathlib.Path("default-reproduction.nix").write_bytes(
        ${lib.strings.escapePythonBytes textFileData}  # noqa: E501
    )
  '';
in
pkgs.runCommandWith
  {
    name = "test-escapePythonBytes";
    derivationArgs = {
      inherit allBytesExceptNullPath emptyFilePath textFilePath;
      nativeBuildInputs = [ pythonTestScript ];
    };
  }
  ''
    function compare_original_and_reproduction {
      if ! diff "$1" "$2"
      then
        printf 'Test failed. %q does not match %q.\n' "$1" "$2"
        exit 1
      fi
    }

    reproduce-test-data-using-escapePythonBytes
    compare_original_and_reproduction "$allBytesExceptNullPath" all-bytes-except-null-reproduction.bin
    compare_original_and_reproduction "$emptyFilePath" empty-file-reproduction.bin
    compare_original_and_reproduction "$textFilePath" default-reproduction.nix

    # Normally, I wouldn’t bother creating a directory (I would make "$out" a
    # file), but I have to create a directory or else the call to symlinkJoin
    # in ../release.nix will fail.
    mkdir "$out"
    echo Test finished successfully! | tee "$out/README.txt"
  ''
