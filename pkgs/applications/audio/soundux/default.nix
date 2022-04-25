{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, makeWrapper
, wrapGAppsHook
, libappindicator-gtk3
, pcre
, openssl
, pipewire
, pulseaudio
, webkitgtk
, xorg
, utillinux
, libpulseaudio
, libwnck3
, makeDesktopItem
, libselinux
, libsepol
, libthai
, libdatrie
, libxkbcommon
, epoxy
, dbus
, downloaderSupport ? true
, ffmpeg
, youtube-dl
, copyDesktopItems
}:

stdenv.mkDerivation rec {
  pname = "soundux";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "Soundux";
    repo = "Soundux";
    rev = version;
    sha256 = "15kd9vl7inn8zm5cqzjkb6zb9xk2xxwpkm7fx1za3dy9m61sq839";
  };

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  dontWrapGApps = true;

  installPhase = ''
    mkdir -p $out/opt $out/bin $out/share
    cp -r dist soundux-${version} $out/opt
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = "Soundux";
      genericName = meta.description;
      categories = [ "Audio" ];
    })
  ];

  postFixup = ''
    makeWrapper $out/opt/soundux-${version} $out/bin/soundux \
      --prefix LD_LIBRARY_PATH ":" ${lib.makeLibraryPath [ libpulseaudio pipewire libwnck3 ]} \
      "''${gappsWrapperArgs[@]}" \
      ${lib.optionalString downloaderSupport "--prefix PATH \":\" " + (lib.makeBinPath [ ffmpeg youtube-dl ])}
  '';

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    ninja
    pkg-config
    makeWrapper
    wrapGAppsHook
  ];

  buildInputs = [
    libappindicator-gtk3
    openssl
    libselinux
    libsepol
    libthai
    libdatrie
    utillinux
    pcre
    pipewire
    pulseaudio
    webkitgtk
    xorg.libX11
    xorg.libXtst
    xorg.libXdmcp
    libxkbcommon
    epoxy
    dbus
  ];

  meta = with lib; {
    homepage = "https://soundux.rocks/";
    description = "cross-platform soundboard";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pasqui23 ];
  };
}
