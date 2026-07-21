{
  fetchCrate,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "spr";
  version = "1.3.7";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-YmmPxsDoV1sYmqY0Jfqm3xTPmu7WWuIUQyOaICu3stM=";
  };

  cargoHash = "sha256-cQsxRrs/pBe/xmqpp5vi1VRJo8jCAufYJrMigxs/tWY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "Submit pull requests for individual, amendable, rebaseable commits to GitHub";
    mainProgram = "spr";
    homepage = "https://github.com/spacedentist/spr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ spacedentist ];
  };
})
