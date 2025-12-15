{
  cmake,
  fetchFromGitHub,
  lib,
  ninja,
  qt6Packages,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "qolibri";
  version = "2.1.5-unstable-2025-01-18";

  src = fetchFromGitHub {
    owner = "mvf";
    repo = "qolibri";
    rev = "edc0683915c0a99872a4c04ff53afe0f5df101fb";
    hash = "sha256-RPcA9pPbd86gJtoHxalDKze0t8DNg/uVQYp9eYTxxyc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    qt6Packages.qt5compat
    qt6Packages.qtmultimedia
    qt6Packages.qtwebengine
  ];

  cmakeFlags = [
    (lib.cmakeOptionType "filepath" "QOLIBRI_EB_SOURCE_DIR"
      "${fetchFromGitHub {
        owner = "mvf";
        repo = "eb";
        rev = "58e1c3bb9847ed5d05863f478f21e7a8ca3d74c8";
        hash = "sha256-gZP+2P6fFADWht2c0hXmljVJQX8RpCq2mWP+KDi+GzE=";
      }}"
    )
  ];

  postInstall = ''
    install -Dm644 $src/qolibri.desktop -t $out/share/applications

    for size in 16 32 48 64 128; do
      install -Dm644 \
        $src/images/qolibri-$size.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/qolibri.png
    done
  '';

  meta = {
    description = "EPWING reader for viewing Japanese dictionaries";
    homepage = "https://github.com/mvf/qolibri";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.azahi ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64; # Looks like a libcxx version mismatch problem.
    mainProgram = "qolibri";
  };
}
