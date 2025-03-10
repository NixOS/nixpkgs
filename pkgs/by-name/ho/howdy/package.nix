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
    p.elevate
    # TODO: remove overrides when https://github.com/NixOS/nixpkgs/pull/273665 is merged
    (p.face-recognition.override {
      dlib = p.dlib.overrideAttrs (_: {
        doCheck = false;
        doInstallCheck = false;
      });
    })
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
  version = "2.6.1-unstable-2024-05-04";

  src = fetchFromGitHub {
    owner = "boltgolt";
    repo = "howdy";
    rev = "aa75c7666c040c6a7c83cd92b9b81a6fea4ce97c";
    hash = "sha256-oYw2xoqLdERy51fYk6zLUZ5Agkr6OKFcvUnFgvHH5rU=";
  };

  patches = [
    # Don't install the config file. We handle it in the module.
    ./dont-install-config.patch

    # Wait for the direct child process (auth client), and not ANY child
    # process, which may allow authentication when it shouldn't
    # https://github.com/boltgolt/howdy/issues/969
    ./waitpid.patch
  ];

  mesonFlags = [
    "-Dconfig_dir=/etc/howdy"
    "-Duser_models_dir=/var/lib/howdy/models"
  ];

  postPatch = ''
    substituteInPlace howdy/src/cli/config.py \
      --replace '/bin/nano' 'nano'

    # wrap howdy and howdy-gtk
    substituteInPlace howdy/src/pam/main.cc \
      --replace "python3" "${py}/bin/python"
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

  postInstall =
    let
      inherit (lib) mapAttrsToList concatStrings;
    in
    ''
      # install dlib data
      rm -rf $out/share/dlib-data/*
      ${concatStrings (
        mapAttrsToList (n: v: ''
          bzip2 -dc ${v} > $out/share/dlib-data/${n}
        '') data
      )}

      # install desktop item & image
      mkdir -p $out/share/applications
      mkdir -p $out/share/icons/hicolor/{48x48,128x128,256x256}/apps
      cp "${desktopItem}"/share/applications/* "$out/share/applications/"
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
