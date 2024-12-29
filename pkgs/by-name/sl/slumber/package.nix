{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    rev = "refs/tags/v${version}";
    hash = "sha256-/WMtAievM0l6rOw03EaZAZMWEJgtxTmtDuKBJM/lz1k=";
  };

  cargoHash = "sha256-1br2LsxPnPpod5u6bvkB9nJTDMMAEU8TL71FDffegOU=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  meta = with lib; {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    changelog = "https://github.com/LucasPickering/slumber/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "slumber";
    maintainers = with maintainers; [ javaes ];
  };
}
