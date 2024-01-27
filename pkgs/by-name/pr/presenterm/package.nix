{ lib
, fetchFromGitHub
, rustPlatform
, libsixel
}:

rustPlatform.buildRustPackage rec {
  pname = "presenterm";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "presenterm";
    rev = "refs/tags/v${version}";
    hash = "sha256-OHp/qbuaZ7uVydKGnSiBR5KQGdf8rWQQWRHrka+PI1M=";
  };

  buildInputs = [
    libsixel
  ];

  cargoHash = "sha256-ymSTloz7sPAtMZN1uDgLs89gMcU+UTsMVc6y5UHt7no=";

  buildFeatures = [ "sixel" ];

  # Skip test that currently doesn't work
  checkFlags = [ "--skip=execute::test::shell_code_execution" ];

  meta = with lib; {
    description = "A terminal based slideshow tool";
    changelog = "https://github.com/mfontanini/presenterm/releases/tag/v${version}";
    homepage = "https://github.com/mfontanini/presenterm";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mikaelfangel ];
    mainProgram = "presenterm";
  };
}
