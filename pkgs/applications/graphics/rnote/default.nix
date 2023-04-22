{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, alsa-lib
, appstream-glib
, cmake
, desktop-file-utils
, glib
, gstreamer
, gtk4
, libadwaita
, libxml2
, meson
, ninja
, pkg-config
, poppler
, python3
, rustPlatform
, shared-mime-info
, wrapGAppsHook4
, AudioUnit
}:

stdenv.mkDerivation rec {
  pname = "rnote";
  version = "0.5.18";

  src = fetchFromGitHub {
    owner = "flxzt";
    repo = "rnote";
    rev = "v${version}";
    hash = "sha256-N07Y9kmGvMFS0Kq4i2CltJvNTuqbXausZZGjAQRDmNU=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ink-stroke-modeler-rs-0.1.0" = "sha256-+R3T/9Ty+F6YxxtA0Un6UhFyKbGOvqBKwHt4WSHWhsk=";
      "librsvg-2.55.92" = "sha256-WVwxjjWR/TloSmyzH8Jo1mTjLHVifBw1Xn965wuoEDs=";
      "piet-0.6.2" = "sha256-76yeX0yQMC0hh6u2xT/kS/2fjs+GO+nCks2fnOImf0c=";
    };
  };

  patches = [
    # https://github.com/flxzt/rnote/pull/569
    (fetchpatch {
      url = "https://github.com/flxzt/rnote/commit/8585b446c08b246f3d55359026415cb3d242d44e.patch";
      hash = "sha256-ePpTQ/3mzZTNjU9P4vTu9CM0vX8+r8b6njuj7hDgFCg=";
    })
  ];

  nativeBuildInputs = [
    appstream-glib # For appstream-util
    cmake
    desktop-file-utils # For update-desktop-database
    meson
    ninja
    pkg-config
    python3 # For the postinstall script
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
    shared-mime-info # For update-mime-database
    wrapGAppsHook4
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    glib
    gstreamer
    gtk4
    libadwaita
    libxml2
    poppler
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
  ] ++ lib.optionals stdenv.isDarwin [
    AudioUnit
  ];

  postPatch = ''
    pushd build-aux
    chmod +x cargo_build.py meson_post_install.py
    patchShebangs cargo_build.py meson_post_install.py
    substituteInPlace meson_post_install.py --replace "gtk-update-icon-cache" "gtk4-update-icon-cache"
    popd
  '';

  meta = with lib; {
    homepage = "https://github.com/flxzt/rnote";
    changelog = "https://github.com/flxzt/rnote/releases/tag/${src.rev}";
    description = "Simple drawing application to create handwritten notes";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda yrd ];
    platforms = platforms.unix;
  };
}
