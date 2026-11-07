{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  makeWrapper,
  img2pdf,
  zathura,
}:

stdenvNoCC.mkDerivation {
  pname = "manga-cli";
  version = "unstable-2022-02-08";

  src = fetchFromGitHub {
    owner = "stl3";
    repo = "manga-cli";
    rev = "75c061f4a3b4fd76c289348fb04a4b4894eb251c";
    sha256 = "sha256-o3C84w9MhE16YHzbFzzlozhirqNS2RhBHRCRyWoxU3w=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 manga-cli $out/bin/manga-cli

    wrapProgram $out/bin/manga-cli \
      --prefix PATH : ${
        lib.makeBinPath [
          img2pdf
          zathura
        ]
      }

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/7USTIN/manga-cli";
    description = "Bash script for reading mangas via the terminal by scraping manganato";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ baitinq ];
    mainProgram = "manga-cli";
  };
}
