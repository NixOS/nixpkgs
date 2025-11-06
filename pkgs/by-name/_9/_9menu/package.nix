{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  libX11,
  libXext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "9menu";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "arnoldrobbins";
    repo = "9menu";
    tag = "9menu-release-${finalAttrs.version}";
    hash = "sha256-J0vHArLH8WDCOvbbF4TYd9b75+5UkhnVdhbbeiUJ4SM=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];
  buildInputs = [
    libX11
    libXext
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "9menu-release-([0-9.]+)"
    ];
  };

  meta = {
    homepage = "https://github.com/arnoldrobbins/9menu";
    description = "Simple X11 menu program for running commands";
    mainProgram = "9menu";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = libX11.meta.platforms;
  };
})
