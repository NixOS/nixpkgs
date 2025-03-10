{
  lib,
  fetchFromGitHub,
  rustPlatform,
  fontconfig,
  pkg-config,
  wayland,
  libxkbcommon,
  makeWrapper,
}:

rustPlatform.buildRustPackage rec {
  pname = "kickoff";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "j0ru";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-q/+Ik8L58LxOllpEosYyvD38RJb+NIQHslYpgGSwjKc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-iTTwclBbmOALjMnT89w6k8Ix8HKTbBOxKHVgePbbXkA=";

  libPath = lib.makeLibraryPath [
    wayland
    libxkbcommon
  ];

  buildInputs = [
    fontconfig
    libxkbcommon
  ];
  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  postInstall = ''
    wrapProgram "$out/bin/kickoff" --prefix LD_LIBRARY_PATH : "${libPath}"
  '';

  meta = with lib; {
    description = "Minimalistic program launcher";
    mainProgram = "kickoff";
    homepage = "https://github.com/j0ru/kickoff";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pyxels ];
    platforms = platforms.linux;
  };
}
