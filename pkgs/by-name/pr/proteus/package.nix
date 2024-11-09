{ lib, stdenv, fetchFromGitHub, autoPatchelfHook, cmake, pkg-config
, alsa-lib, freetype, libjack2
, libX11, libXext, libXcursor, libXinerama, libXrandr, libXrender
}:

stdenv.mkDerivation rec {
  pname = "proteus";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "GuitarML";
    repo = "Proteus";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-WhJh+Sx64JYxQQ1LXpDUwXeodFU1EZ0TmMhn+6w0hQg=";
  };

  nativeBuildInputs = [ autoPatchelfHook cmake pkg-config ];
  buildInputs = [
    alsa-lib freetype libjack2
    libX11 libXext libXcursor libXinerama libXrandr libXrender
  ];
  # JUCE loads most dependencies at runtime:
  runtimeDependencies = map lib.getLib buildInputs;

  env.NIX_CFLAGS_COMPILE = toString [
    # Support JACK output in the standalone application:
    "-DJUCE_JACK"
    # Accommodate -flto:
    "-ffat-lto-objects"
  ];

  # The default "make install" only installs JUCE, which should not be installed, and does not install proteus.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -rT Proteus_artefacts/*/Standalone $out/bin
    cp -rT Proteus_artefacts/*/LV2 $out/lib/lv2
    cp -rT Proteus_artefacts/*/VST3 $out/lib/vst3

    runHook postInstall
  '';

  meta = with lib; {
    description = "Guitar amp and pedal capture plugin using neural networks";
    homepage = "https://github.com/GuitarML/Proteus";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
    mainProgram = "Proteus";
  };
}
