{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "hck";
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = "hck";
    rev = "v${version}";
    hash = "sha256-cycM40fm0bc6SCgGsMTKFVPUtjcXGpoMo3KhDDo74ZQ=";
  };

  cargoHash = "sha256-1Kaob5OZiM9WZ6lwuRvuDMtHVolRPjApQtQ52TQhs8A=";

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Close to drop in replacement for cut that can use a regex delimiter instead of a fixed string";
    homepage = "https://github.com/sstadick/hck";
    changelog = "https://github.com/sstadick/hck/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      unlicense
    ];
    maintainers = with lib.maintainers; [
      gepbird
    ];
    mainProgram = "hck";
  };
}
