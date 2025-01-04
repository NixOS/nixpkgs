{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  pkg-config,
  gcc12,
  alsa-lib,
  xorg,
  freetype,
  libGLU,
  libjack2,
  juce,
  unzip,
}:
let
  juce' = juce.overrideAttrs rec {
    version = "8.0.4";
  };
  clap-juce-extensions = fetchFromGitHub {
    owner = "free-audio";
    repo = "clap-juce-extensions";
    rev = "4f33b4930b6af806018c009f0f24b3a50808af99";
    hash = "sha256-M+T7ll3Ap6VIP5ub+kfEKwT2RW2IxxY4wUPRQKFIotk=";
    fetchSubmodules = true;
  };
in
stdenv.mkDerivation {
  pname = "airwin2rack-juce";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "baconpaul";
    repo = "airwin2rack";
    rev = "db56d13f853831ab94a5e1713282e4e518f50d5c";
    hash = "sha256-utqDmQgnYUtUv0E0xhO5rGx+9RXTAn8kKhTzkyXjcbE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    gcc12
    unzip
  ];

  buildInputs = [
    gcc12
    alsa-lib
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXext
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    libGLU
    libjack2
    freetype
    juce'
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_JUCE_PLUGIN" true)
    (lib.cmakeBool "USE_JUCE_PROGRAMS" true)
  ];

  cmakeBuildType = "Release";

  patches = [
    ./0000-juce-clap-juce-extensions-src-juce-cmakelists.patch
  ];

  preConfigure = ''
    ln -s ${juce'.src} src-juce/juce
    ln -s ${clap-juce-extensions} src-juce/clap-juce-extensions
  '';

  buildPhase = ''
    cmake --build . --config Release --target awcons-installer --parallel $NIX_BUILD_CORES
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p temp
    unzip installer/AirwindowsConsolidated-1980-01-01-unknownhash-Linux.zip -d temp

    mkdir -p $out/lib/vst3 $out/lib/lv2 $out/lib/clap $out/bin

    cp -r "temp/awcons-products/Airwindows Consolidated.vst3" $out/lib/vst3
    cp -r "temp/awcons-products/Airwindows Consolidated.lv2" $out/lib/lv2
    install -Dm644 "temp/awcons-products/Airwindows Consolidated.clap" -t $out/lib/clap

    install -Dm755 "temp/awcons-products/Airwindows Consolidated" $out/bin/Airwindows\ Consolidated
    ln -s $out/bin/Airwindows\ Consolidated $out/bin/airwindows-consolidated

    runHook postInstall
  '';

  NIX_LDFLAGS = (
    toString [
      "-lX11"
      "-lXext"
      "-lXcomposite"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
      "-lXrender"
    ]
  );

  meta = {
    description = "JUCE Plugin Version of Airwindows Consolidated";
    homepage = "https://airwindows.com/";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    mainProgram = "airwindows-consolidated";
    maintainers = [ lib.maintainers.l1npengtul ];
  };
}
