{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  alsa-lib,
  gcc-unwrapped,
  libX11,
  libcxx,
  libdrm,
  libgbm,
  libglvnd,
  libpulseaudio,
  libxcb,
  wayland,
  xz,
  zlib,
  libva,
  libvdpau,
  addDriverRunpath,
  freetype,
  harfbuzz,
  fontconfig,
  fribidi,
}:
let
  arch =
    {
      aarch64-linux = "arm64";
      x86_64-linux = "amd64";
    }
    .${stdenv.hostPlatform.system};
in
stdenv.mkDerivation rec {
  pname = "mdk-sdk";
  version = "0.35.0";

  src = fetchurl {
    url = "https://github.com/wang-bin/mdk-sdk/releases/download/v${version}/mdk-sdk-linux.tar.xz";
    hash = "sha256-PKECwms/JGJYsYIvUWU0UBSLwlsYikYw3IGleWXlbtg=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    alsa-lib
    gcc-unwrapped
    libX11
    libcxx
    libdrm
    libgbm
    libglvnd
    libpulseaudio
    libxcb
    wayland
    xz
    zlib
    freetype
    harfbuzz
    fontconfig
    fribidi
  ];

  appendRunpaths = lib.makeLibraryPath [
    libva
    libvdpau
    addDriverRunpath.driverLink
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r include $out/include
    cp -r lib/${arch} $out/lib
    cp -r lib/cmake $out/lib/cmake
    ln -s . $out/lib/${arch}

    runHook postInstall
  '';

  meta = {
    description = "Multimedia development kit";
    homepage = "https://github.com/wang-bin/mdk-sdk";
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
