{
  stdenv,
  lib,
  copyDesktopItems,
  fetchFromGitHub,
  fetchpatch,
  fetchurl,
  bzip2,
  gobject-introspection,
  imagemagick,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  makeDesktopItem,
  makeWrapper,
  fmt,
  gettext,
  gtk3,
  inih,
  libevdev,
  pam,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "howdy";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "boltgolt";
    repo = "howdy";
    # The 3.0.0 release does not have a corresponding tag yet.
    # The maintainer was asked to provide one here https://github.com/boltgolt/howdy/pull/1023#issuecomment-3722339500
    rev = "d3ab99382f88f043d15f15c1450ab69433892a1c";
    hash = "sha256-Xd/uScMnX1GMwLD5GYSbE2CwEtzrhwHocsv0ESKV8IM=";
  };

  patches = [
    # Allows specifying whether to install config file. Paired with the
    # `install_config` meson option. Needed to disallow installing the config
    # file in `/etc/howdy`, as it is not allowed by the Nix sandbox. A NixOS
    # module creates `/etc/howdy` and the config file of course.
    # PR sent upstream https://github.com/boltgolt/howdy/pull/1050
    (fetchpatch {
      url = "https://github.com/boltgolt/howdy/commit/1f3b83e2db5a8dfd9c7c88706ecce033e154060a.patch";
      hash = "sha256-OIN8A4q0zjtMOMzZgBqrKy2qOD8BDPB+euG6zerFbCE=";
    })

    # Fix python path for howdy-gtk. Uses python from meson option instead of
    # the system installation (which is not defined in this package).
    # PR sent upstream https://github.com/boltgolt/howdy/pull/1049
    (fetchpatch {
      url = "https://github.com/boltgolt/howdy/commit/b056724f84361dc6150554e7a806152af032c54b.patch";
      hash = "sha256-ZOb+QmWagKWtyXI0Xg00tnw8UP8uDWw7wb4Fwjy3VeE=";
    })
  ];

  mesonFlags = lib.concatLists [
    (lib.mapAttrsToList lib.mesonOption {
      config_dir = "/etc/howdy";
      python_path = "${finalAttrs.finalPackage.pythonEnv}/bin/python";
      user_models_dir = "/var/lib/howdy/models";
    })
    (lib.mapAttrsToList lib.mesonBool {
      install_config = false;
      with_polkit = true;
    })
  ];

  nativeBuildInputs = [
    bzip2
    copyDesktopItems
    gobject-introspection
    imagemagick
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    makeWrapper
  ];

  buildInputs = [
    fmt
    gettext
    gtk3
    inih
    libevdev
    pam
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "howdy";
      exec = "howdy-gtk";
      icon = "howdy";
      comment = "Howdy facial authentication";
      desktopName = "Howdy";
      genericName = "Facial authentication";
      categories = [
        "System"
        "Security"
      ];
    })
  ];

  postInstall = ''
    # install dlib data
    rm -rf $out/share/dlib-data/*
    ${lib.concatStrings (
      lib.mapAttrsToList (n: v: ''
        bzip2 -dc ${v} > $out/share/dlib-data/${n}.dat
      '') finalAttrs.finalPackage.passthru.dlibModels
    )}

    for size in 16 24 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick -background none "$out/share/howdy-gtk/logo.png" -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/howdy.png
    done

    chmod +x $out/lib/howdy-gtk/init.py
  '';

  pythonEnv = python3.buildEnv.override {
    extraLibs = lib.attrVals finalAttrs.finalPackage.passthru.pythonDeps python3.pkgs;
    makeWrapperArgs = [
      "--set"
      "OMP_NUM_THREADS"
      "1"
    ];
  };

  passthru = {
    pythonDeps = [
      "dlib"
      "elevate"
      "face-recognition"
      "keyboard"
      "opencv4Full"
      "pycairo"
      "pygobject3"
    ];
    dlibModels = lib.mapAttrs (
      name: hash:
      fetchurl {
        name = "howdy-${name}.dat";
        url = "https://github.com/davisking/dlib-models/raw/daf943f7819a3dda8aec4276754ef918dc26491f/${name}.dat.bz2";
        inherit hash;
      }
    ) finalAttrs.finalPackage.passthru.dlibModelsHashes;
    dlibModelsHashes = {
      dlib_face_recognition_resnet_model_v1 = "sha256-q7H2EEHkNEZYVc6Bwr1UboMNKLy+2NJ/++W7QIsRVTo=";
      mmod_human_face_detector = "sha256-256eQPCSwRjV6z5kOTWyFoOBcHk1WVFVQcVqK1DZ/IQ=";
      shape_predictor_5_face_landmarks = "sha256-bnh7vr9cnv23k/bNHwIyMMRBMwZgXyTymfEoaflapHI=";
    };
  };

  meta = {
    description = "Windows Hello™ style facial authentication for Linux";
    homepage = "https://github.com/boltgolt/howdy";
    license = lib.licenses.mit;
    mainProgram = "howdy";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fufexan ];
  };
})
