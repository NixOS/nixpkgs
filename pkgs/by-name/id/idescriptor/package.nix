{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  avahi,
  avahi-compat,
  coreutils,
  ffmpeg,
  fuse3,
  glib,
  gst_all_1,
  ifuse,
  libheif,
  libplist,
  libssh2,
  openssl,
  polkit,
  qt6,
  util-linux,
}:

let
  gstPluginsGoodQt6 = gst_all_1.gst-plugins-good.override {
    qt6Support = true;
  };
  gstPlugins = with gst_all_1; [
    gstreamer
    gst-plugins-base
    gstPluginsGoodQt6
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ];
  runtimePrograms = [
    coreutils
    fuse3
    ifuse
    polkit
    util-linux
  ];

  qtEnv = qt6.env "qt6-idescriptor" [ qt6.qtdeclarative ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "idescriptor";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "iDescriptor";
    repo = "iDescriptor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d2edq6NMDf4wgvKi29S+LpxCxyunDTwMOm90WmB6O1Y=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-QQcl/l6a4v75QE5xtOu8uWOyg0HD0juRyFl+s8GgEt4=";
  };

  buildFeatures = [ "package_manager" ];

  env = {
    IDESCRIPTOR_PACKAGE_MANAGER_MESSAGE = "Please update iDescriptor with the Nix profile or system configuration that installed it.";
    QT_INCLUDE_PATH = "${qtEnv}/include";
    QT_LIBRARY_PATH = "${qtEnv}/lib";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    avahi
    avahi-compat
    ffmpeg
    glib
    libheif
    libplist
    libssh2
    openssl
    qt6.qt5compat
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtlocation
    qt6.qtmultimedia
    qt6.qtpositioning
    qt6.qtserialport
    qt6.qtshadertools
    qt6.qtsvg
  ]
  ++ gstPlugins;

  postInstall = ''
    ln -s "$out/bin/idescriptor" "$out/bin/iDescriptor"

    install -Dm644 ${./99-idevice.rules} $out/lib/udev/rules.d/99-idevice.rules

    install -Dm644 io.github.idescriptor.iDescriptor.desktop \
      $out/share/applications/io.github.idescriptor.iDescriptor.desktop
    install -Dm644 io.github.idescriptor.iDescriptor.metainfo.xml \
      $out/share/metainfo/io.github.idescriptor.iDescriptor.metainfo.xml

    for size in 16 32 256 512; do
      install -Dm644 \
        packaging/shared/resources/app-icon/icon-$size.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/io.github.idescriptor.iDescriptor.png
    done
  '';

  preFixup = ''
    qtWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath runtimePrograms}
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ${lib.makeSearchPath "lib/gstreamer-1.0" gstPlugins}
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/iDescriptor/iDescriptor";
    changelog = "https://github.com/iDescriptor/iDescriptor/releases/tag/v${finalAttrs.version}";
    description = "A cross-platform iDevice management tool";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ amadejkastelic ];
    mainProgram = "idescriptor";
  };
})
