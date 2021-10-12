{ lib, stdenv, fetchFromGitHub, pkg-config, fetchzip
, libjack2, alsa-lib, freetype, libX11, libXrandr, libXinerama, libXext, libXcursor
, libGL, python3, ncurses, libusb1
, gtk3, webkitgtk, curl, xvfb-run, makeWrapper
  # "Debug", or "Release"
, buildType ? "Release"
}:

let
  projucer = stdenv.mkDerivation rec {
    pname = "projucer";
    version = "5.4.7";

    src = fetchFromGitHub {
      owner = "juce-framework";
      repo = "JUCE";
      rev = version;
      sha256= "0qpiqfwwpcghk7ij6w4vy9ywr3ryg7ppg77bmd7783kxg6zbhj8h";
    };

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [
      freetype libX11 libXrandr libXinerama libXext gtk3 webkitgtk
      libjack2 curl
    ];
    preBuild = ''
      cd extras/Projucer/Builds/LinuxMakefile
    '';
    makeFlags = [ "CONFIG=${buildType}" ];
    enableParallelBuilding = true;

    installPhase = ''
      mkdir -p $out/bin
      cp -a build/Projucer $out/bin/Projucer
    '';
  };

  # equal to vst-sdk in ../oxefmsynth/default.nix
  vst-sdk = stdenv.mkDerivation rec {
    name = "vstsdk3610_11_06_2018_build_37";
    src = fetchzip {
      url = "https://web.archive.org/web/20181016150224if_/https://download.steinberg.net/sdk_downloads/${name}.zip";
      sha256 = "0da16iwac590wphz2sm5afrfj42jrsnkr1bxcy93lj7a369ildkj";
    };
    installPhase = ''
      cp -r . $out
    '';
  };

in
stdenv.mkDerivation rec {
  pname = "bespokesynth";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "awwbees";
    repo = pname;
    rev = "v${version}";
    sha256 = "04b2m40jszphslkd4850jcb8qwls392lwy3lc6vlj01h4izvapqk";
  };

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    xvfb-run sh -e <<EOF
      ${projucer}/bin/Projucer --set-global-search-path linux defaultJuceModulePath ${projucer.src}/modules
      ${projucer}/bin/Projucer --resave BespokeSynth.jucer
    EOF

    runHook postConfigure
  '';
  CFLAGS = "-I${vst-sdk}/VST2_SDK";

  nativeBuildInputs = [ xvfb-run pkg-config python3 makeWrapper ];

  buildInputs = [
    libX11 libXrandr libXinerama libXext libXcursor freetype libGL
    ncurses libusb1
    alsa-lib libjack2
  ];

  preBuild = ''
    cd Builds/LinuxMakefile
  '';
  makeFlags = [ "CONFIG=${buildType}" ];
  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/bespokesynth $out/share/applications $out/share/icons/hicolor/512x512/apps
    cp build/BespokeSynth $out/bin/
    cp -ar ../MacOSX/build/Release/resource $out/share/bespokesynth/
    wrapProgram $out/bin/BespokeSynth \
      --run "cd $out/share/bespokesynth"

    mkdir -p $out/share/applications/ $out/share/icons/hicolor/512x512/apps/
    cp ../../bespoke_icon.png $out/share/icons/hicolor/512x512/apps/
    substitute ../../BespokeSynth.desktop $out/share/applications/BespokseSynth.desktop \
      --replace "/usr/bin/" ""

    runHook postInstall
  '';

  meta = with lib; {
    description = "Software modular synth with controllers support, scripting and VST";
    homepage = "https://github.com/awwbees/BespokeSynth";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ astro ];
    platforms = platforms.all;
  };
}
