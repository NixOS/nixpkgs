{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  libevdev,
  libgee,
  udev,
  testers,
  nix-update-script,
}:

let
  # https://github.com/v1993/evdevhook2/blob/main/subprojects/gcemuhook.wrap
  gcemuhook = fetchFromGitHub {
    name = "gcemuhook";
    owner = "v1993";
    repo = "gcemuhook";
    rev = "91ef61cca809f5f3b9fa6e5304aba284a56c06dc";
    hash = "sha256-CPjSuKtoqSDKd+vEBgFy3qh33TkCVbxBEnwiBAkaADs=";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "evdevhook2";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "v1993";
    repo = "evdevhook2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6CnUYLgrGUM1ndGpbn/T7wkREUzQ1LsLMpkRRxyUZ50=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    libevdev
    libgee
    udev
  ];

  postUnpack = ''
    ln -sf ${gcemuhook} source/subprojects/gcemuhook
  '';

  mesonBuildType = "release";

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "Evdevhook ${finalAttrs.version}";
    };

    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/v1993/evdevhook2/releases/tag/v${finalAttrs.version}";
    description = "Cemuhook UDP server for devices with modern Linux drivers";
    homepage = "https://github.com/v1993/evdevhook2";
    license = lib.licenses.gpl3Only;
    mainProgram = "evdevhook2";
    maintainers = with lib.maintainers; [ azuwis ];
    platforms = lib.platforms.linux;
  };
})
