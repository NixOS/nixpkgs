{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  srcOnly,
  nim-2_0,
  nim-unwrapped-2_0,
}:

let
  buildNimPackage' = buildNimPackage.override {
    # Do not build with Nim-2.2.x.
    nim2 = nim-2_0;
  };
in
buildNimPackage' (finalAttrs: {
  pname = "nimlsp";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "PMunch";
    repo = "nimlsp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MCtpCx8jMQp0VXuMowh69d1DQreU5cDftBf0lww7PUM=";
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
    "-d:explicitSourcePath=${srcOnly nim-unwrapped-2_0}"
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
    maintainers = with lib.maintainers; [ xtrayambak ];
  };
})
