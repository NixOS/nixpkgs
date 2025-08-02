{
  stdenv,
  lib,
  fetchFromGitHub,
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
  writeShellScriptBin,
}:

let
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) concatLists;
  inherit (lib.strings) concatStrings mesonBool mesonOption;

  data =
    let
      baseurl = "https://github.com/davisking/dlib-models/raw/daf943f7819a3dda8aec4276754ef918dc26491f";
    in
    {
      "dlib_face_recognition_resnet_model_v1.dat" = fetchurl {
        url = "${baseurl}/dlib_face_recognition_resnet_model_v1.dat.bz2";
        hash = "sha256-q7H2EEHkNEZYVc6Bwr1UboMNKLy+2NJ/++W7QIsRVTo=";
      };
      "mmod_human_face_detector.dat" = fetchurl {
        url = "${baseurl}/mmod_human_face_detector.dat.bz2";
        hash = "sha256-256eQPCSwRjV6z5kOTWyFoOBcHk1WVFVQcVqK1DZ/IQ=";
      };
      "shape_predictor_5_face_landmarks.dat" = fetchurl {
        url = "${baseurl}/shape_predictor_5_face_landmarks.dat.bz2";
        hash = "sha256-bnh7vr9cnv23k/bNHwIyMMRBMwZgXyTymfEoaflapHI=";
      };
    };

  # wrap howdy and howdy-gtk
  py = python3.withPackages (p: [
    p.dlib
    p.elevate
    p.face-recognition.override
    p.keyboard
    (p.opencv4.override { enableGtk3 = true; })
    p.pycairo
    p.pygobject3
  ]);

  wrappedPy = writeShellScriptBin "python-howdy-wrapper" ''
    export OMP_NUM_THREADS=1
    exec ${py.interpreter} "$@"
  '';

  desktopItem = makeDesktopItem {
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
  };
in
stdenv.mkDerivation {
  pname = "howdy";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "boltgolt";
    repo = "howdy";
    rev = "d3ab99382f88f043d15f15c1450ab69433892a1c";
    hash = "sha256-Xd/uScMnX1GMwLD5GYSbE2CwEtzrhwHocsv0ESKV8IM=";
  };

  patches = [
    # Don't install the config file. We handle it in the module.
    ./dont-install-config.patch

    # Fix python path for howdy-gtk
    ./fix-gtk-py-path.patch
  ];

  mesonFlags = concatLists [
    (mapAttrsToList mesonOption {
      config_dir = "/etc/howdy";
      python_path = "${wrappedPy}/bin/python-howdy-wrapper";
      user_models_dir = "/var/lib/howdy/models";
    })
    (mapAttrsToList mesonBool {
      with_polkit = true;
    })
  ];

  nativeBuildInputs = [
    bzip2
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
    py
  ];

  postInstall = ''
    # install dlib data
    rm -rf $out/share/dlib-data/*
    ${concatStrings (
      mapAttrsToList (n: v: ''
        bzip2 -dc ${v} > $out/share/dlib-data/${n}
      '') data
    )}

    mkdir -p $out/share/applications
    cp "${desktopItem}"/share/applications/* "$out/share/applications/"

    for size in 16 24 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick -background none "$out/share/howdy-gtk/logo.png" -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/howdy.png
    done
  '';

  meta = {
    description = "Windows Hello™ style facial authentication for Linux";
    homepage = "https://github.com/boltgolt/howdy";
    license = lib.licenses.mit;
    mainProgram = "howdy";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fufexan ];
  };
}
