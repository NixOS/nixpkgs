{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, dbus
, ffmpeg
, x264
, libva
, gst_all_1
, xorg
, libdrm
, pkg-config
, pango
, cmake
, autoconf
, libtool
, nodePackages
, ApplicationServices
, Carbon
, Cocoa
, VideoToolbox
}:

rustPlatform.buildRustPackage rec {
  pname = "weylus";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "H-M-H";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gq2czxvahww97j4i3k18np29zl6wx85f8253wn3ibqrpfnklz6l";
  };

  buildInputs = [
    ffmpeg
    x264
  ] ++ lib.optionals stdenv.isDarwin [
    ApplicationServices
    Carbon
    Cocoa
    VideoToolbox
  ] ++ lib.optionals stdenv.isLinux [
    dbus
    libva
    gst_all_1.gst-plugins-base
    xorg.libXext
    xorg.libXft
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXrender
    xorg.libXfixes
    xorg.libXtst
    xorg.libXrandr
    xorg.libXcomposite
    xorg.libXi
    xorg.libXv
    pango
    libdrm
  ];

  nativeBuildInputs = [
    cmake
    nodePackages.typescript
  ] ++ lib.optionals stdenv.isLinux [
    pkg-config
    autoconf
    libtool
  ];

  cargoSha256 = "1pigmch0sy9ipsafd83b8q54xwqjxdaif363n1q8n46arq4v81j0";

  cargoBuildFlags = [ "--features=ffmpeg-system" ];
  cargoTestFlags = [ "--features=ffmpeg-system" ];

  postInstall = ''
    install -vDm755 weylus.desktop $out/share/applications/weylus.desktop
  '';

  meta = with lib; {
    description = "Use your tablet as graphic tablet/touch screen on your computer";
    homepage = "https://github.com/H-M-H/Weylus";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ lom ];
  };
}
