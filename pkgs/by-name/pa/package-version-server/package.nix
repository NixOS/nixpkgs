{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "package-version-server";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "package-version-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1+7oqWiJd7AZUlaDGYRtR1lyenrlhyaaGeWufW9lPUU=";
  };

  cargoHash = "sha256-AOE0fs3QK8vTIMOIxMg6SooDSQVtqFdB0tF3S88J7Ew=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru = {
    updateScript = nix-update-script { };
  };

  # Needs https://github.com/zed-industries/package-version-server/pull/2 to be merged
  doCheck = lib.versionAtLeast finalAttrs.version "0.0.11";

  meta = {
    description = "Language server that handles hover information in package.json files";
    homepage = "https://github.com/zed-industries/package-version-server/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felixdorn ];
    mainProgram = "package-version-server";
  };
})
