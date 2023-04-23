{ alsa-lib
, cmake
, copyDesktopItems
, curl
, fetchFromBitbucket
, fetchFromGitHub
, fetchzip
, ghc_filesystem
, glew
, glfw
, gnome
, gtk3-x11
, imagemagick
, jansson
, jq
, lib
, libarchive
, libicns
, libjack2
, libpulseaudio
, libsamplerate
, libXext
, libXi
, makeDesktopItem
, makeWrapper
, pkg-config
, rtmidi
, speexdsp
, stdenv
, wrapGAppsHook
, zstd
}:

let
  # The package repo vendors some of the package dependencies as submodules.
  # Unfortunately, they are not pinned, so we have no guarantee that they
  # will be stable, and therefore, we can't use them directly. Instead
  # we'll have to fetch them separately ourselves.
  pffft-source = fetchFromBitbucket {
    owner = "jpommier";
    repo = "pffft";
    rev = "988259a41d1522047a9420e6265a6ba8289c1654";
    sha256 = "Oq5N02UNXsbhcPUfjMtD0cgqAZsGx9ke9A+ArrenzGE=";
  };
  fuzzysearchdatabase-source = fetchFromBitbucket {
    owner = "j_norberg";
    repo = "fuzzysearchdatabase";
    rev = "a3a1bf557b8e6ee58b55fa82ff77ff7a3d141949";
    sha256 = "13ib72acbxn1cnf66im0v4nlr1464v7j08ra2bprznjmy127xckm";
  };
  nanovg-source = fetchFromGitHub {
    owner = "VCVRack";
    repo = "nanovg";
    rev = "0bebdb314aff9cfa28fde4744bcb037a2b3fd756";
    sha256 = "HmQhCE/zIKc3f+Zld229s5i5MWzRrBMF9gYrn8JVQzg=";
  };
  nanosvg-source = fetchFromGitHub {
    owner = "memononen";
    repo = "nanosvg";
    rev = "ccdb1995134d340a93fb20e3a3d323ccb3838dd0";
    sha256 = "ymziU0NgGqxPOKHwGm0QyEdK/8jL/QYk5UdIQ3Tn8jw=";
  };
  osdialog-source = fetchFromGitHub {
    owner = "AndrewBelt";
    repo = "osdialog";
    rev = "21b9dcc2a1bbdacb9b46da477ffd82a4ce9204b9";
    sha256 = "+4VCBuQvfiuEUdjFu3IB2FwbHFrDJXTb4vcVg6ZFwSM=";
  };
  oui-blendish-source = fetchFromGitHub {
    owner = "AndrewBelt";
    repo = "oui-blendish";
    rev = "2fc6405883f8451944ed080547d073c8f9f31898";
    sha256 = "/QZFZuI5kSsEvSfMJlcqB1HiZ9Vcf3vqLqWIMEgxQK8=";
  };
  simde-source = fetchFromGitHub {
    owner = "simd-everywhere";
    repo = "simde";
    rev = "dd0b662fd8cf4b1617dbbb4d08aa053e512b08e4";
    sha256 = "1kxwzdlh21scak7wsbb60vwfvndppidj5fgbi26mmh73zsj02mnv";
  };
  tinyexpr-source = fetchFromGitHub {
    owner = "codeplea";
    repo = "tinyexpr";
    rev = "4e8cc0067a1e2378faae23eb2dfdd21e9e9907c2";
    sha256 = "1yxkxsw3bc81cjm2knvyr1z9rlzwmjvq5zd125n34xwq568v904d";
  };
  fundamental-source = fetchFromGitHub {
    owner = "VCVRack";
    repo = "Fundamental";
    rev = "f80e1a0e78dc043a0ff0b777ef98a36b91063622"; # tip of branch v2
    sha256 = "0hnwrr1xhf7dpkw1v63f633x5dlrvijgbah4aj5h5xr2jchip9nx";
  };
  vcv-rtaudio = stdenv.mkDerivation rec {
    pname = "vcv-rtaudio";
    version = "unstable-2020-01-30";

    src = fetchFromGitHub {
      owner = "VCVRack";
      repo = "rtaudio";
      rev = "ece277bd839603648c80c8a5f145678e13bc23f3"; # tip of master branch
      sha256 = "11gpl0ak757ilrq4fi0brj0chmlcr1hihc32yd7qza4fxjw2yx2v";
    };

    nativeBuildInputs = [ cmake pkg-config ];

    buildInputs = [ alsa-lib libjack2 libpulseaudio ];

    cmakeFlags = [
      "-DRTAUDIO_API_ALSA=ON"
      "-DRTAUDIO_API_PULSE=ON"
      "-DRTAUDIO_API_JACK=ON"
      "-DRTAUDIO_API_CORE=OFF"
    ];
  };
in
stdenv.mkDerivation rec {
  pname = "VCV-Rack";
  version = "2.2.1";

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = pname;
      desktopName = "VCV Rack";
      genericName = "Eurorack simulator";
      comment = "Create music by patching together virtual synthesizer modules";
      exec = "Rack";
      icon = "Rack";
      categories = [ "AudioVideo" "AudioVideoEditing" "Audio" ];
      keywords = [ "music" ];
    })
  ];

  src = fetchFromGitHub {
    owner = "VCVRack";
    repo = "Rack";
    rev = "v${version}";
    sha256 = "079alr6y0101k92v5lrnycljcbifh0hsvklbf4w5ax2zrxnyplq8";
  };

  patches = [
    ./rack-minimize-vendoring.patch
  ];

  prePatch = ''
    # As we can't use `make dep` to set up the dependencies (as explained
    # above), we do it here manually
    mkdir -p dep/include

    cp -r ${pffft-source}/* dep/pffft
    cp -r ${fuzzysearchdatabase-source}/* dep/fuzzysearchdatabase
    cp -r ${nanovg-source}/* dep/nanovg
    cp -r ${nanosvg-source}/* dep/nanosvg
    cp -r ${osdialog-source}/* dep/osdialog
    cp -r ${oui-blendish-source}/* dep/oui-blendish
    cp -r ${simde-source}/* dep/simde
    cp -r ${tinyexpr-source}/* dep/tinyexpr

    cp dep/pffft/*.h dep/include
    cp dep/fuzzysearchdatabase/src/*.hpp dep/include
    cp dep/nanosvg/**/*.h dep/include
    cp dep/nanovg/src/*.h dep/include
    cp dep/osdialog/*.h dep/include
    cp dep/oui-blendish/*.h dep/include
    cp -r dep/simde/simde dep/include
    cp dep/tinyexpr/tinyexpr.h dep/include

    # Build and dist the Fundamental plugins
    cp -r ${fundamental-source} plugins/Fundamental/
    chmod -R +rw plugins/Fundamental # will be used as build dir
    substituteInPlace plugin.mk --replace ":= all" ":= dist"

    # Fix reference to zenity
    substituteInPlace dep/osdialog/osdialog_zenity.c \
      --replace 'zenityBin[] = "zenity"' 'zenityBin[] = "${gnome.zenity}/bin/zenity"'
  '';

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
    jq
    libicns
    makeWrapper
    pkg-config
    wrapGAppsHook
  ];
  buildInputs = [
    alsa-lib
    curl
    ghc_filesystem
    glew
    glfw
    gnome.zenity
    gtk3-x11
    jansson
    libarchive
    libjack2
    libpulseaudio
    libsamplerate
    rtmidi
    speexdsp
    vcv-rtaudio
    zstd
  ];

  makeFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ] ++ [
    "all"
    "plugins"
  ];

  installPhase = ''
    runHook preInstall

    install -D -m755 -t $out/bin Rack
    install -D -m755 -t $out/lib libRack.so

    mkdir -p $out/share/vcv-rack
    cp -r res cacert.pem Core.json template.vcv LICENSE-GPLv3.txt $out/share/vcv-rack
    cp -r plugins/Fundamental/dist/Fundamental-*.vcvplugin $out/share/vcv-rack/Fundamental.vcvplugin

    # Extract pngs from the Apple icon image and create
    # the missing ones from the 1024x1024 image.
    icns2png --extract icon.icns
    for size in 16 24 32 48 64 128 256 512 1024; do
      mkdir -pv $out/share/icons/hicolor/"$size"x"$size"/apps
      if [ ! -e icon_"$size"x"$size"x32.png ] ; then
        convert -resize "$size"x"$size" icon_1024x1024x32.png icon_"$size"x"$size"x32.png
      fi
      install -Dm644 icon_"$size"x"$size"x32.png $out/share/icons/hicolor/"$size"x"$size"/apps/Rack.png
    done;

    runHook postInstall
  '';

  dontWrapGApps = true;
  postFixup = ''
    # Wrap gApp and override the default global resource file directory
    wrapProgram $out/bin/Rack \
        "''${gappsWrapperArgs[@]}" \
        --add-flags "-s $out/share/vcv-rack"
  '';

  meta = with lib; {
    description = "Open-source virtual modular synthesizer";
    homepage = "https://vcvrack.com/";
    # The source is GPL3+ licensed, some of the art is CC-BY-NC 4.0 or under a
    # no-derivatives clause
    license = with licenses; [ gpl3Plus cc-by-nc-40 unfreeRedistributable ];
    maintainers = with maintainers; [ nathyong jpotier ddelabru ];
    platforms = platforms.linux;
  };
}
