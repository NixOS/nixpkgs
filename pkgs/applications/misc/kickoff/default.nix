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
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "j0ru";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WUDbb/GLABhqE93O6bm19Y+r0kSMEJrvduw68Igub44=";
  };

  cargoHash = "sha256-nhUC9PSKAbNEK5e4WRx3dgYI0rJP5XSWcW6M5E0Ihv4=";

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
