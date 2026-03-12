{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  srcOnly,
  nim,
  nim-unwrapped,
}: buildNimPackage ({
  pname = "nimlsp";
  version = "0-unstable-09-02-2026";

  src = fetchFromGitHub {
    owner = "PMunch";
    repo = "nimlsp";
    rev = "5fa2846f04600c2cf1173625976e037389db4489";
    hash = "sha256-lpOhlKWbHej0OATdqnCA0Dv7S89v76wRMNwuTVsH4nw=";
  };

  lockFile = ./lock.json;

  buildInputs =
    let
      # Needs this specific version to build.
      jsonSchemaSrc = fetchFromGitHub {
        owner = "PMunch";
        repo = "jsonschema";
        rev = "7b41c03e3e1a487d5a8f6b940ca8e764dc2cbabf";
        hash = "sha256-f9F1oam/ZXwDKXqGMUUQ5+tMZKTe7t4UlZ4U1LAkRss=";
      };
    in
    [ jsonSchemaSrc ];

  nimFlags = [
    "--threads:on"
    "-d:explicitSourcePath=${srcOnly nim-unwrapped}"
    "-d:tempDir=/tmp"
  ];

  nimDefines = [
    "nimcore"
    "nimsuggest"
    "debugCommunication"
    "debugLogging"
  ];

  doCheck = false;

  meta = {
    description = "Language Server Protocol implementation for Nim";
    homepage = "https://github.com/PMunch/nimlsp";
    license = lib.licenses.mit;
    mainProgram = "nimlsp";
    maintainers = with lib.maintainers; [ xtrayambak zodman ];
  };
})
