{
  stdenv,
  autoPatchelfHook,
  autoAddDriverRunpath,
  e2fsprogs,
  fontconfig,
  freetype,
  gnutar,
  gst_all_1,
  gzip,
  libGL,
  libkrb5,
  libtiff,
  libxkbcommon,
  nss,
  numactl,
  perl,
  pulseaudio,
  qt6,
  qt6Packages,
  rdma-core,
  ucx,
  wayland,
  wrapGAppsHook3,
  libice,
  libsm,
  libxcursor,
  libxdamage,
  libxrandr,
  libxtst,
  libxcb,
  libxkbfile,
  libxshmfence,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-wm,
  fetchurl,
  lib,
  pname,
  version,
  url,
  hash,
  extraBuildInputs ? [ ],
}:
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    inherit url hash;
  };

  preUnpack = ''
    cp $src ./installer.run
    # Stop the installer doing some stuff that prevents us seeing errors
    sed -i \
      -e '1,300s!> */dev/tty!>\&2!g' \
      -e '1,300s!kill -15 \$\$!exit 1!g' \
      installer.run
  '';

  strictDeps = true;

  __structuredAttrs = true;

  dontBuild = true;

  dontPatchELF = true;

  nativeBuildInputs = [
    autoPatchelfHook
    gnutar
    gzip
    perl
    qt6.wrapQtAppsHook
    wrapGAppsHook3
    autoAddDriverRunpath
  ];

  buildInputs = extraBuildInputs ++ [
    e2fsprogs
    fontconfig
    freetype
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    libGL
    libkrb5
    libtiff
    libxkbcommon
    nss
    numactl
    pulseaudio
    qt6Packages.qtbase
    qt6Packages.qtscxml
    qt6Packages.qtsvg
    qt6Packages.qttools
    qt6Packages.qtwayland
    qt6Packages.qtwebengine
    rdma-core
    ucx
    wayland
    libice
    libsm
    libxcursor
    libxdamage
    libxrandr
    libxtst
    libxcb
    libxkbfile
    libxshmfence
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm
  ];

  autoPatchelfIgnoreMissingDeps = [
    # libcuda needs to be resolved during runtime
    "libcuda.so"
    "libcuda.so.*"
    "libnvidia-ml.so.*"

    "libQt6WaylandEglClientHwIntegration.so.6"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    "libglapi.so.0"
  ];

  installPhase = ''
    runHook preInstall

    patchShebangs ./install-linux.pl
    mkdir -p $out/opt
    ./install-linux.pl -targetpath $out/opt -noprompt

    runHook postInstall
  '';
}
