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
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "j0ru";
    repo = "kickoff";
    rev = "v${version}";
    hash = "sha256-V4MkVjg5Q8eAJ80V/4SvEIwjVy35/HVewaR1caYLguw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bkum6NOQL0LVsLvOmKljFHE86ZU3lLDR8+I3wL0Efmk=";

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
