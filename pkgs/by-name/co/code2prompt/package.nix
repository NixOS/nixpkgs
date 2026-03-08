{
  lib,
  fetchCrate,
  perl,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "code2prompt";
  version = "4.2.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-Zp0wQhy1xSB71tF2nbiyRbP1I/0icZs2Zik1A/y2vLs=";
  };

  cargoHash = "sha256-JsuRPtqS9cJbwPPQYWcOZX2krhnx0lLin87Sc1+s+WY=";

  buildFeatures = lib.optionals stdenv.hostPlatform.isLinux [ "wayland" ];

  nativeBuildInputs = [ perl ];

  meta = {
    description = "CLI tool that converts your codebase into a single LLM prompt with a source tree, prompt templating, and token counting";
    homepage = "https://github.com/mufeedvh/code2prompt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ heisfer ];
    mainProgram = "code2prompt";
  };
})
