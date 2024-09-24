{ stdenv
, lib
, fetchFromGitHub
, cmake
, ninja
, qttools
, qtwebengine
, wrapQtAppsHook
}:

let
  eb = fetchFromGitHub {
    owner = "mvf";
    repo = "eb";
    rev = "58e1c3bb9847ed5d05863f478f21e7a8ca3d74c8";
    hash = "sha256-gZP+2P6fFADWht2c0hXmljVJQX8RpCq2mWP+KDi+GzE=";
  };
in

stdenv.mkDerivation {
  pname = "qolibri";
  version = "2.1.5-unstable-2024-03-17";

  src = fetchFromGitHub {
    owner = "mvf";
    repo = "qolibri";
    rev = "99f0771184fcb2c5f47aad11c16002ebb8469a3f";
    hash = "sha256-ArupqwejOO2YK9a3Ky0j20dIHs1jIqJksNIb4K2jwgI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtwebengine
  ];

  cmakeFlags = [
    "-DQOLIBRI_EB_SOURCE_DIR=${eb}"
  ];

  postInstall = ''
    install -Dm644 $src/qolibri.desktop -t $out/share/applications

    for size in 16 32 48 64 128; do
      install -Dm644 \
        $src/images/qolibri-$size.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/qolibri.png
    done
  '';

  meta = with lib; {
    description = "EPWING reader for viewing Japanese dictionaries";
    homepage = "https://github.com/mvf/qolibri";
    license = licenses.gpl2;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64; # Looks like a libcxx version mismatch problem.
    mainProgram = "qolibri";
  };
}
