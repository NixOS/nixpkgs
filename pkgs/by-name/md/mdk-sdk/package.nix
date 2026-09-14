{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  alsa-lib,
  gcc-unwrapped,
  libx11,
  libcxx,
  libdrm,
  libgbm,
  libglvnd,
  libpulseaudio,
  libxcb,
  lz4,
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
    .${stdenv.hostPlatform.system} or "";

  version = "0.37.0";

  linux = {
    url = "https://github.com/wang-bin/mdk-sdk/releases/download/v${version}/mdk-sdk-linux.tar.xz";
    hash = "sha256-bBneSsNHfMH2MoDddT1cOtnyWjRNYHo0UTqnjrLpk4Q=";
  };

  darwin = {
    url = "https://github.com/wang-bin/mdk-sdk/releases/download/v${version}/mdk-sdk-apple.tar.xz";
    hash = "sha256-KGKzwy/unzkCUoh/dGjk0BVEUgDdMx5jy1Qt5C357DQ=";
  };

  sources = {
    aarch64-linux = linux;
    x86_64-linux = linux;
    aarch64-darwin = darwin;
  };

  source =
    sources.${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "mdk-sdk";
  inherit version;

  src = fetchurl { inherit (source) url hash; };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  dontStrip = stdenv.hostPlatform.isDarwin;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    gcc-unwrapped
    libx11
    libcxx
    libdrm
    libgbm
    libglvnd
    libpulseaudio
    libxcb
    lz4
    wayland
    xz
    zlib
    freetype
    harfbuzz
    fontconfig
    fribidi
  ];

  appendRunpaths = lib.optionalString stdenv.hostPlatform.isLinux (
    lib.makeLibraryPath [
      libva
      libvdpau
      addDriverRunpath.driverLink
    ]
  );

  autoPatchelfIgnoreMissingDeps = lib.optionals stdenv.hostPlatform.isLinux [
    "librockchip_mpp.so.1"
  ];

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/lib $out/Frameworks
        cp -a lib/mdk.xcframework/macos-arm64_x86_64/mdk.framework $out/lib/
        cp -a lib/cmake $out/lib/cmake
        ln -s ../lib/mdk.framework $out/Frameworks/mdk.framework
        cp -a include $out/include

        runHook postInstall
      ''
    else
      ''
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
    platforms = builtins.attrNames sources;
  };
}
