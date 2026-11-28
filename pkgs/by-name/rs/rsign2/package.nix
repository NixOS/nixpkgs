{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rsign2";
  version = "0.6.7";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-wqIckE3yG99kaycpwYSEIH2m/reZMfoDKN26jDTH3u4=";
  };

  cargoHash = "sha256-llZiklXfBrBLnB3Y+HDiAi1g7QzARaeun/q/wPAwLp4=";

  meta = {
    description = "Command-line tool to sign files and verify signatures";
    homepage = "https://github.com/jedisct1/rsign2";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "rsign";
  };
})
