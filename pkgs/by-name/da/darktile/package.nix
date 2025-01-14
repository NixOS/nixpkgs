{
  fetchFromGitHub,
  lib,
  pkg-config,
  libX11,
  libXcursor,
  libXrandr,
  libXinerama,
  libXi,
  libXext,
  libXxf86vm,
  libGL,
  nixosTests,
  buildGoModule,
}:

buildGoModule rec {
  pname = "darktile";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = "darktile";
    rev = "v${version}";
    hash = "sha256-M3vySAyYwqscR9n0GGXp1ttO/mhdSCponZNYJRBBI18=";
  };

  vendorHash = null;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libX11
    libXcursor
    libXrandr
    libXinerama
    libXi
    libXext
    libXxf86vm
    libGL
  ];

  passthru.tests.test = nixosTests.terminal-emulators.darktile;

  meta = with lib; {
    description = "GPU rendered terminal emulator designed for tiling window managers";
    homepage = "https://github.com/liamg/darktile";
    downloadPage = "https://github.com/liamg/darktile/releases";
    changelog = "https://github.com/liamg/darktile/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.linux;
    badPlatforms = [ "aarch64-linux" ];
    maintainers = with maintainers; [ mikaelfangel ];
    mainProgram = "darktile";
  };
}
