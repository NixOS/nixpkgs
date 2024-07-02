{ lib
, stdenv
, fetchFromGitHub
, fetchFromGitLab
, cargo
, desktop-file-utils
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, wrapGAppsHook4
, libadwaita
, pipewire
, wireplumber
}:

let
  wireplumber_0_4 = wireplumber.overrideAttrs (attrs: rec {
    version = "0.4.17";
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "pipewire";
      repo = "wireplumber";
      rev = version;
      hash = "sha256-vhpQT67+849WV1SFthQdUeFnYe/okudTQJoL3y+wXwI=";
    };
  });
in
stdenv.mkDerivation rec {
  pname = "pwvucontrol";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "saivert";
    repo = "pwvucontrol";
    rev = version;
    hash = "sha256-Y8/W0gPWWYatZ/voAX7iddEtmZ2/lIpcuBPNaH52WGQ=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "wireplumber-0.1.0" = "sha256-r3p4OpmMgiFgjn1Fj4LeMOhx6R2UWollIdJRy/0kiNM=";
    };
  };

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    pipewire
    wireplumber_0_4
  ];

  strictDeps = true;

  meta = with lib; {
    description = "Pipewire volume control applet";
    homepage = "https://github.com/saivert/pwvucontrol";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda Guanran928 aleksana ];
    mainProgram = "pwvucontrol";
    platforms = platforms.linux;
  };
}
