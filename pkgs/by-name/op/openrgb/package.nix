{
  lib,
  stdenv,
  fetchFromGitLab,
  libsForQt5,
  libusb1,
  hidapi,
  pkg-config,
  coreutils,
  mbedtls_2,
  symlinkJoin,
  openrgb,
}:

stdenv.mkDerivation rec {
  pname = "openrgb";
  version = "0.9-unstable-2025-02-13";

  src = fetchFromGitLab {
    owner = "CalcProgrammer1";
    repo = "OpenRGB";
    rev = "bb6f8e2dddc1f5ba218275150b22f37b095b9e4f";
    hash = "sha256-6zOyY2CcUUIyhrp2H2jBAJqcjAbppDUGewCZZSUUeHo=";
  };

  nativeBuildInputs = with libsForQt5; [
    qmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = with libsForQt5; [
    libusb1
    hidapi
    mbedtls_2
    qtbase
    qttools
  ];

  postPatch = ''
    patchShebangs scripts/build-udev-rules.sh
    substituteInPlace scripts/build-udev-rules.sh \
      --replace /bin/chmod "${coreutils}/bin/chmod"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    HOME=$TMPDIR $out/bin/openrgb --help > /dev/null
  '';

  passthru.withPlugins =
    plugins:
    let
      pluginsDir = symlinkJoin {
        name = "openrgb-plugins";
        paths = plugins;
        # Remove all library version symlinks except one,
        # or they will result in duplicates in the UI.
        # We leave the one pointing to the actual library, usually the most
        # qualified one (eg. libOpenRGBHardwareSyncPlugin.so.1.0.0).
        postBuild = ''
          for f in $out/lib/*; do
            if [ "$(dirname $(readlink "$f"))" == "." ]; then
              rm "$f"
            fi
          done
        '';
      };
    in
    openrgb.overrideAttrs (old: {
      qmakeFlags = old.qmakeFlags or [ ] ++ [
        # Welcome to Escape Hell, we have backslashes
        ''DEFINES+=OPENRGB_EXTRA_PLUGIN_DIRECTORY=\\\""${
          lib.escape [ "\\" "\"" " " ] (toString pluginsDir)
        }/lib\\\""''
      ];
    });

  meta = {
    description = "Open source RGB lighting control";
    homepage = "https://gitlab.com/CalcProgrammer1/OpenRGB";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "openrgb";
  };
}
