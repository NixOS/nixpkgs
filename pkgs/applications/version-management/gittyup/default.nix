{ lib
, stdenv
, fetchFromGitHub
, cmark
, mount
, http-parser
, perl
, cmake
, qtbase
, qttools
, git
, git-lfs
, ninja
, libssh2
, libgit2
, pkg-config
, libsecret
, libgnome-keyring
, pcre
, wrapQtAppsHook
, makeDesktopItem
}:
stdenv.mkDerivation rec {
  pname = "gittyup";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Murmele";
    repo = "Gittyup";
    rev = "gittyup_v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-WJzw1uFCE5dyI1F0FEzww05zCsYPEgeXBz+HogTYX9w=";
  };

  nativeBuildInputs = [
    cmark
    mount
    http-parser
    perl
    cmake
    qttools
    ninja
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    git
    git-lfs
    libssh2
    libgit2
    libsecret
    libgnome-keyring
    pcre
  ];

  cmakeFlage = [
    "-W no-dev"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_PREFIX_PATH=${qtbase}"
    "-DENABLE_REPRODUCIBLE_BUILDS=ON"
    "-DBUILD_SHARED_LIBS=OFF"
  ];

  desktopItem = makeDesktopItem {
    name = "Gittyup";
    exec = "gittyup";
    icon = pname;
    type = "Application";
    comment = meta.description;
    desktopName = "Gittyup";
    genericName = "Text Editor";
    categories = [ "GNOME" "GTK" "Application" "Development" ];
    startupNotify = true;
    terminal = false;
  };

  postInstall = ''
    # Move all created files to subdirectory
    shopt -s extglob
    mkdir -p $out/temp
    mv $out/!(temp) $out/temp
    mkdir -p $out/lib
    mv $out/temp $out/lib/gittyup

    # Remove unnecessary files
    rm -rf "$out/lib/gittyup/"*.so.*
    rm -rf "$out/lib/gittyup/Plugins"
    rm -rf "$out/lib/gittyup/lib"
    rm -rf "$out/lib/gittyup/lib64"
    rm -rf "$out/lib/gittyup/include"
    rm -rf "$out/lib/gittyup/share"

    # Move the executable to the correct location
    install -d "$out/bin"
    ln -s $out/lib/gittyup/Gittyup "$out/bin/gittyup"
    chmod 0755 "$out/bin/gittyup"

    # Install the gittyup icons
    install -Dm644 $src/rsrc/Gittyup.iconset/gittyup_logo.svg "$out/share/icons/hicolor/scalable/apps/${pname}.svg"
    for s in 16x16 32x32 64x64 128x128 256x256 512x512; do
      install -Dm0644 "$src/rsrc/Gittyup.iconset/icon_$s.png" "$out/share/icons/hicolor/$s/apps/${pname}.png"
    done

    # Create desktop item, so we can pick it from the KDE/GNOME menu
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';

  meta = with lib; {
    description = "A graphical Git client designed to help you understand and manage your source code history";
    homepage = "https://github.com/Murmele/Gittyup";
    license = licenses.mit;
    maintainers = with maintainers; [ zebreus ];
  };
}
