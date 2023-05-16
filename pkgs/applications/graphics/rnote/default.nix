{ lib
, stdenv
, fetchFromGitHub
, alsa-lib
, appstream-glib
, cargo
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
, rustc
, shared-mime-info
, wrapGAppsHook4
, AudioUnit
}:

stdenv.mkDerivation rec {
  pname = "rnote";
<<<<<<< HEAD
  version = "0.7.1";
=======
  version = "0.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "flxzt";
    repo = "rnote";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-QcgmL6lLi/3QXnlcEsVyTqNUfjSm+R+nhRzRvw8M9Qc=";
=======
    hash = "sha256-47mWlUXp62fMh5c13enFjmuMxzrmEZlwJFsZhYCB1Vs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
<<<<<<< HEAD
      "ink-stroke-modeler-rs-0.1.0" = "sha256-1abfrPehOGc/ye/iFIwYPd6HJX6P8OP2vGBSJfeo+c8=";
      "librsvg-2.56.2" = "sha256-uCHKDC4nc7J0k9qsmzF6etkWOoNq51Dddd9uQw5DOT0=";
=======
      "ink-stroke-modeler-rs-0.1.0" = "sha256-DrbFolHGL3ywk2p6Ly3x0vbjqxy1mXld+5CPrNlJfQM=";
      "librsvg-2.56.0" = "sha256-4poP7xsoylmnKaUWuJ0tnlgEMpw9iJrM3dvt4IaFi7w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      "piet-0.6.2" = "sha256-If0qiZkgXeLvsrECItV9/HmhTk1H52xmVO7cUsD9dcU=";
    };
  };

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
    cargo
    rustc
    shared-mime-info # For update-mime-database
    wrapGAppsHook4
  ];

  dontUseCmakeConfigure = true;

  mesonFlags = [
    (lib.mesonBool "cli" true)
  ];

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
