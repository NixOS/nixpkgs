{ lib
, fetchFromGitHub
, rustPlatform
, libsixel
}:

rustPlatform.buildRustPackage rec {
  pname = "presenterm";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "presenterm";
    rev = "refs/tags/v${version}";
    hash = "sha256-8oLqZfpkSbGg85vj5V54D052vmmoMRzQmiQzOwCOSxg=";
  };

  buildInputs = [
    libsixel
  ];

  cargoHash = "sha256-SJpmQMUm5+0mUmYq2pv4JLV6PxZs2g3TrWqTlHElS3Q=";

  buildFeatures = [ "sixel" ];

  # Skip test that currently doesn't work
  checkFlags = [ "--skip=execute::test::shell_code_execution" ];

  meta = with lib; {
    description = "A terminal based slideshow tool";
    homepage = "https://github.com/mfontanini/presenterm";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mikaelfangel ];
    mainProgram = "presenterm";
  };
}
