{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, makeBinaryWrapper
, pipewire
, libpulseaudio
, libappindicator
, libstartup_notification
, openssl
, libwnck
, pcre
, util-linux
, libselinux
, libsepol
, libthai
, libdatrie
, xorg
, libxkbcommon
, libepoxy
, dbus
, at-spi2-core
, nlohmann_json
, fancypp
, httplib
, semver-cpp
, webkitgtk
, yt-dlp
, ffmpeg
, lsb-release
}:

stdenv.mkDerivation rec {
  pname = "soundux";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "Soundux";
    repo = "Soundux";
    rev = version;
    sha256 = "sha256-aSCsg6nJt6F+6O7UeXnvYva0vllTfsxK/cjaeOhObZY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    pipewire
    libpulseaudio
    libappindicator
    openssl
    libwnck
    pcre
    util-linux
    libselinux
    libsepol
    libthai
    libdatrie
    xorg.libXdmcp
    xorg.libXtst
    xorg.libXres
    libxkbcommon
    libepoxy
    dbus
    at-spi2-core
    nlohmann_json
    fancypp
    httplib
    semver-cpp
    libstartup_notification
    webkitgtk
    yt-dlp
    ffmpeg
  ];

  postPatch = ''
    # cannot be overwritten with variables
    substituteInPlace CMakeLists.txt \
      --replace "set(CMAKE_INSTALL_PREFIX \"/opt/soundux\" CACHE PATH \"Install path prefix, prepended onto install directories.\" FORCE)" "" \
      --replace "/usr/share" "$out/usr/share"
    substituteInPlace src/ui/impl/webview/webview.cpp \
      --replace "/usr/share/pixmaps/soundux.png" "$out/share/pixmaps/soundux.png"
  '';

  # We need to append /opt to our CMAKE_INSTALL_PREFIX
  dontAddPrefix = true;

  preConfigure = ''
    # This needs to be set in preConfigure to access the $prefix variable
    export cmakeFlags="-DCMAKE_INSTALL_PREFIX=$prefix/opt $cmakeFlags"

    # Replace some fetched submodules with symlinks nix packages.
    rm -rf \
      lib/json \
      lib/fancypp \
      lib/lib-httplib \
      lib/semver

    ln -s ${nlohmann_json} lib/json
    ln -s ${fancypp} lib/fancypp
    ln -s ${httplib} lib/lib-httplib
    ln -s ${semver-cpp} lib/semver
  '';

  NIX_CFLAGS_COMPILE = [ "-Wno-error=deprecated-declarations" ];

  # Somehow some of the install destination paths in the build system still
  # gets transformed to point to /var/empty/share, even though they are at least
  # relative to the nix output directory with our earlier patching.
  postInstall = ''
    mv "$out/var/empty/share" "$out"
    rm -rf "$out/var"
    mkdir "$out/bin"
    ln -s "$out/opt/soundux" "$out/bin"
    substituteInPlace "$out/share/applications/soundux.desktop" \
      --replace "/opt/soundux/soundux" "soundux"
  '';

  postFixup = let
    rpaths = lib.makeLibraryPath [libwnck pipewire libpulseaudio];
  in ''
    # Wnck, PipeWire, and PulseAudio are dlopen-ed by Soundux, so they do
    # not end up on the RPATH during the build process.
    patchelf --add-rpath "${rpaths}" "$out/opt/soundux-${version}"

    # Work around upstream bug https://github.com/Soundux/Soundux/issues/435
    wrapProgram "$out/bin/soundux" \
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1 \
      --prefix PATH : ${lib.makeBinPath [ yt-dlp ffmpeg lsb-release ]} \
  '';

  meta = with lib; {
    description = "A cross-platform soundboard.";
    homepage = "https://soundux.rocks/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ aidalgol ];
  };
}
