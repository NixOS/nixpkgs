{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, makeWrapper
, dbus
, ffmpeg
, x264
, libva
, gst_all_1
, xorg
, libdrm
, pkg-config
, pango
, pipewire
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
  version = "unstable-2022-06-07";

  src = fetchFromGitHub {
    owner = "H-M-H";
    repo = pname;
    rev = "b169a6be2bf3e8d105273d92f032cca5438de53a";
    sha256 = "sha256-J9eVFIfmyBviVuT1MYKb5yoacbPqOAT3A8jahWv5qw8=";
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
    makeWrapper
  ] ++ lib.optionals stdenv.isLinux [
    pkg-config
    autoconf
    libtool
  ];

  cargoSha256 = "sha256-R46RSRdtfqi1PRQ0MaSIIqtj+Pr3yikm6NeMwwu1CSw=";

  cargoBuildFlags = [ "--features=ffmpeg-system" ];
  cargoTestFlags = [ "--features=ffmpeg-system" ];

  postFixup = let
    GST_PLUGIN_PATH = lib.makeSearchPathOutput  "lib" "lib/gstreamer-1.0" [
      gst_all_1.gst-plugins-base
      pipewire
    ];
  in lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/weylus --prefix GST_PLUGIN_PATH : ${GST_PLUGIN_PATH}
  '';

  postInstall = ''
    install -vDm755 weylus.desktop $out/share/applications/weylus.desktop
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Use your tablet as graphic tablet/touch screen on your computer";
    homepage = "https://github.com/H-M-H/Weylus";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ lom ];
  };
}
