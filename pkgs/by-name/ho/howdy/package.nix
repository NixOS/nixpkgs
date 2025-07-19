{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchurl,
  bzip2,
  gobject-introspection,
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
        sha256 = "0fjm265l1fz5zdzx5n5yphl0v0vfajyw50ffamc4cd74848gdcdb";
      };
      "mmod_human_face_detector.dat" = fetchurl {
        url = "${baseurl}/mmod_human_face_detector.dat.bz2";
        sha256 = "117wv582nsn585am2n9mg5q830qnn8skjr1yxgaiihcjy109x7nv";
      };
      "shape_predictor_5_face_landmarks.dat" = fetchurl {
        url = "${baseurl}/shape_predictor_5_face_landmarks.dat.bz2";
        sha256 = "0wm4bbwnja7ik7r28pv00qrl3i1h6811zkgnjfvzv7jwpyz7ny3f";
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
  version = "2.6.1-unstable-2025-02-02";

  src = fetchFromGitHub {
    owner = "boltgolt";
    repo = "howdy";
    rev = "c4521c14ab8c672cadbc826a3dbec9ef95b7adb1";
    hash = "sha256-y/BVj6DdnppIegAEm2FtrOdiqF23Q+U6v2EZ4A9H7iU=";
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
      python_path = "python";
      user_models_dir = "/var/lib/howdy/models";
    })
    (mapAttrsToList mesonBool {
      with_polkit = true;
    })
  ];

  postPatch = ''
    substituteInPlace howdy/src/cli/config.py \
      --replace-fail '/bin/nano' 'nano'
  '';

  nativeBuildInputs = [
    bzip2
    gobject-introspection
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
    mkdir -p $out/share/icons/hicolor/{48x48,128x128,256x256}/apps
    cp "${desktopItem}"/share/applications/* "$out/share/applications/"
    # TODO: resize images
    ln -s "$out/share/howdy-gtk/logo.png" $out/share/icons/hicolor/48x48/apps/howdy.png
    ln -s "$out/share/howdy-gtk/logo.png" $out/share/icons/hicolor/128x128/apps/howdy.png
    ln -s "$out/share/howdy-gtk/logo.png" $out/share/icons/hicolor/256x256/apps/howdy.png
  '';

  dontWrapGApps = true;
  dontInstallCheck = true;

  preFixup = ''
    wrapProgramShell $out/bin/howdy \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : ${lib.makeBinPath [ py ]}

    wrapProgramShell $out/bin/howdy-gtk \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : ${lib.makeBinPath [ py ]}
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
