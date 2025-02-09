{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  testers,
  gitMinimal,
  serie,
}:

rustPlatform.buildRustPackage rec {
  pname = "serie";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "serie";
    rev = "v${version}";
    hash = "sha256-NjEom/UZQ/so27sYU5ADEJQL7KhwnunTjjkh3MLliGA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-r6fJ2NsBJaJVJzEnST89VY4wEQdpH1FsadV9BuF/K6E=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      CoreGraphics
      AppKit
    ]
  );

  nativeCheckInputs = [ gitMinimal ];

  passthru.tests.version = testers.testVersion { package = serie; };

  meta = with lib; {
    description = "A rich git commit graph in your terminal, like magic";
    homepage = "https://github.com/lusingander/serie";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "serie";
  };
}
