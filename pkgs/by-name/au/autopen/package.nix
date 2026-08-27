{
  lib,
  callPackage,
  rustPlatform,
  fetchFromGitHub,
  capnproto,
  autopen,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "autopen";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "emilazy";
    repo = "autopen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7/uAwpNNQByKAjrpr6R40dkVWg5t15bqLD4KJNT53wI=";
  };

  cargoHash = "sha256-baV0suVBCgV/gFnAD5uo6fpfQg/CYreyFgsiEGTmH3A=";

  nativeBuildInputs = [
    capnproto
  ];

  useNextest = true;

  cargoTestFlags = [ "--max-fail=all" ];

  strictDeps = true;

  __structuredAttrs = true;

  meta = {
    description = "Cryptographic signing tool with an object‐capability interface";
    homepage = "https://github.com/emilazy/autopen";
    license = lib.licenses.blueOak100;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    teams = [ lib.teams.boot-security ];
    mainProgram = "autopen";
    platforms = lib.platforms.unix;
  };
})
