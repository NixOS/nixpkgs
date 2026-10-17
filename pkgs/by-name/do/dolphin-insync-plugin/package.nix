{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
}:

stdenv.mkDerivation {
  pname = "dolphin-insync-plugin";
  version = "0-unstable-2024-03-12";

  src = fetchFromGitHub {
    owner = "insynchq";
    repo = "dolphin-insync-plugin";
    rev = "9fbf1c18ca14d4111d454a93c41ed2175fdcd4f5";
    hash = "sha256-WgkfIf8RY4mO+JS2EPBFXuJNBM/TQV91uPKOjl0y9qM=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.kio
    kdePackages.kcoreaddons
  ];

  strictDeps = true;
  __structuredAttrs = true;

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON"
    "-DKDE_INSTALL_PLUGINDIR=lib/qt-6/plugins"
  ];

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/scalable/emblems

    cat << 'EOF' > $out/share/icons/hicolor/scalable/emblems/dolphin-emblem-insync-synced.svg
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
      <circle cx="12" cy="12" r="11" fill="#27ae60"/>
      <path fill="#ffffff" d="M10 16.4l-4.2-4.2 1.4-1.4 2.8 2.8 6.8-6.8 1.4 1.4z"/>
    </svg>
    EOF

    cat << 'EOF' > $out/share/icons/hicolor/scalable/emblems/dolphin-emblem-insync-syncing.svg
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
      <circle cx="12" cy="12" r="11" fill="#2980b9"/>
      <path fill="#ffffff" d="M12 5V2l-4 4 4 4V7c2.8 0 5 2.2 5 5h2c0-3.9-3.1-7-7-7zm-7 5c0 3.9 3.1 7 7 7v3l4-4-4-4v3c-2.8 0-5-2.2-5-5H5z"/>
    </svg>
    EOF

    cat << 'EOF' > $out/share/icons/hicolor/scalable/emblems/dolphin-emblem-insync-error.svg
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
      <circle cx="12" cy="12" r="11" fill="#c0392b"/>
      <path fill="#ffffff" d="M11 6h2v8h-2zm0 10h2v2h-2z"/>
    </svg>
    EOF
  '';

  meta = with lib; {
    description = "Dolphin plugin that adds Insync's context menus and overlay icons";
    homepage = "https://www.insynchq.com";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ timh-de ];
  };
}
