{
  lib, stdenv, fetchFromGitHub, cmake, ninja, pkg-config, makeWrapper, wrapGAppsHook,
  libappindicator-gtk3, openssl, pipewire, pulseaudio, webkitgtk, xorg,
  libpulseaudio, libwnck3,
  downloaderSupport ? true, ffmpeg, youtube-dl
}:

let
  downloaderPath = lib.makeBinPath [ffmpeg youtube-dl ];
  # Soundux loads pipewire, pulse and libwnck optionally during runtime
  dynamicLibraries = lib.makeLibraryPath [libpulseaudio pipewire libwnck3 ];
in
stdenv.mkDerivation rec {
  pname = "soundux";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "Soundux";
    repo = "Soundux";
    rev = version;
    fetchSubmodules = true;
    sha256 = "15kd9vl7inn8zm5cqzjkb6zb9xk2xxwpkm7fx1za3dy9m61sq839";
  };

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  dontWrapGApps = true;

  installPhase = ''
    mkdir -p $out/opt $out/bin
    cp -r dist soundux-${version} $out/opt
  '';

  postFixup = ''
    makeWrapper $out/opt/soundux-${version} $out/bin/soundux \
      --prefix LD_LIBRARY_PATH ":" ${dynamicLibraries} \
      "''${gappsWrapperArgs[@]}" \
      ${lib.optionalString downloaderSupport "--prefix PATH \":\" " + downloaderPath}
  '';

  nativeBuildInputs = [ cmake ninja pkg-config makeWrapper wrapGAppsHook ];
  buildInputs = [
    libappindicator-gtk3
    openssl
    pipewire
    pulseaudio
    webkitgtk
    xorg.libX11
    xorg.libXtst
  ];

  meta = with lib; {
    homepage = "https://soundux.rocks/";
    description = "cross-platform soundboard";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dandellion ];
  };
}
