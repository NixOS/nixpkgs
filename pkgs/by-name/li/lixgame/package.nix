{
  stdenv,
  lib,
  makeWrapper,
  fetchurl,
  fetchzip,
  removeReferencesTo,
  dub,
  ldc,
  allegro5,
  enet,
  pkg-config,
}:

let
  _d_dallegro_ver = "4.0.4+5.2.0";
  _d_bolts_ver = "1.3.1";
  _d_derelict_enet_ver = "4.2.0";
  _d_derelict_util_ver = "3.0.0-beta.2";
  _d_enumap_ver = "0.4.2";
  _d_optional_ver = "1.3.0";
  _d_SDLang_ver = "0.10.6";
  _d_taggedalgebraic_ver = "0.11.22";
  _d_unit_threaded_ver = "0.7.55";
in
stdenv.mkDerivation rec {
  pname = "lixgame";
  version = "0.10.9";

  music = fetchzip {
    url = "https://www.lixgame.com/dow/lix-music.zip";
    hash = "sha256-JIXQ+P3AQW7EWVDHlR+Z4SWAxVAFO3d3KeB3QBGx+YQ=";
  };

  srcs = [
    (fetchurl {
      url = "https://github.com/SimonN/LixD/archive/refs/tags/v${version}.tar.gz";
      hash = "sha256-o6WMzmqKCBLN0ITYjnlOFXvgtk4aFtPEqs8K/EJvGQw=";
    })
    (fetchurl {
      url = "https://github.com/SiegeLord/DAllegro5/archive/v${_d_dallegro_ver}.tar.gz";
      hash = "sha256-15ffm1/1LkR/28imxZz4OREod4QYKtKvBvXns38bOyk=";
    })
    (fetchurl {
      url = "https://github.com/aliak00/bolts/archive/v${_d_bolts_ver}.tar.gz";
      hash = "sha256-I78AuwdiEDu3G6+EE8wjV2jrs03grSmRSm5+InCGEZQ=";
    })
    (fetchurl {
      url = "https://github.com/DerelictOrg/DerelictENet/archive/v${_d_derelict_enet_ver}.tar.gz";
      hash = "sha256-rPvZvNwDCPY1LhEHvnI156YDTp06vnCthzBu3jt9gUU=";
    })
    (fetchurl {
      url = "https://github.com/DerelictOrg/DerelictUtil/archive/v${_d_derelict_util_ver}.tar.gz";
      hash = "sha256-1kB3JcwgISH1Y4LfYuCZe0Bn3QXM2ns4fO9dzdvWw8Q=";
    })
    (fetchurl {
      url = "https://github.com/rcorre/enumap/archive/v${_d_enumap_ver}.tar.gz";
      hash = "sha256-SVSFcE+qiHVBdJKl5KNBVSAMtMxRvaXBZ1IzNkY3fhM=";
    })
    (fetchurl {
      url = "https://github.com/aliak00/optional/archive/v${_d_optional_ver}.tar.gz";
      hash = "sha256-s+CWmbakifH2ILdPMTNxjAxfrv7m6XCp6md9Qo4jxpU=";
    })
    (fetchurl {
      url = "https://github.com/Abscissa/SDLang-D/archive/v${_d_SDLang_ver}.tar.gz";
      hash = "sha256-Gxj6x4AbX0rTceG387UcHzXa3nsSP/Vq8WA0ANf5ixE=";
    })
    (fetchurl {
      url = "https://github.com/s-ludwig/taggedalgebraic/archive/v${_d_taggedalgebraic_ver}.tar.gz";
      hash = "sha256-KtAI2JCTSZLwkAjfFg2OIcFaG59GfLm3Xh5wGgU7TjE=";
    })
    (fetchurl {
      url = "https://github.com/atilaneves/unit-threaded/archive/v${_d_unit_threaded_ver}.tar.gz";
      hash = "sha256-uG1EAk7ky/fYGIG4emKIt5TJwkTd0i7OJ4agqf8/nkI=";
    })
  ];

  sourceRoot = ".";

  nativeBuildInputs = [
    dub
    ldc
    makeWrapper
    removeReferencesTo
  ];

  buildInputs = [
    pkg-config
    allegro5
    enet
  ];

  prePatch = ''
    # we need to set the directory for the data in this source variable
    substituteInPlace ./LixD-${version}/src/file/filename/fhs.d \
      --replace "enum customReadOnlyDir = \"\";" "enum customReadOnlyDir = \"$out/share\";"

    substituteInPlace ./LixD-${version}/data/desktop/com.lixgame.Lix.desktop \
     --replace "Icon=com.lixgame.Lix" "Icon=lix"
  '';

  configurePhase = ''
    runHook preConfigure
    mkdir home
    HOME="home" dub add-local SDLang-D-${_d_SDLang_ver} ${_d_SDLang_ver}
    HOME="home" dub add-local DerelictENet-${_d_derelict_enet_ver} ${_d_derelict_enet_ver}
    HOME="home" dub add-local enumap-${_d_enumap_ver} ${_d_enumap_ver}
    HOME="home" dub add-local DAllegro5-4.0.4-5.2.0 ${_d_dallegro_ver}
    HOME="home" dub add-local optional-${_d_optional_ver} ${_d_optional_ver}
    HOME="home" dub add-local taggedalgebraic-${_d_taggedalgebraic_ver} ${_d_taggedalgebraic_ver}
    HOME="home" dub add-local unit-threaded-${_d_unit_threaded_ver} ${_d_unit_threaded_ver}
    HOME="home" dub add-local DerelictUtil-${_d_derelict_util_ver} ${_d_derelict_util_ver}
    HOME="home" dub add-local bolts-${_d_bolts_ver} ${_d_bolts_ver}
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    cd LixD-${version}
    HOME="../home" dub --skip-registry=all build -b releaseXDG
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share}
    mkdir -p $out/share/lix
    mkdir -p $out/share/{licenses,man,icons,applications}
    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp -r data $out/share/lix
    cp -r images $out/share/lix
    cp -r levels $out/share/lix
    cp -r ${music} $out/share/lix/music
    cp bin/lix $out/bin

    install -Dm644 "data/desktop/com.lixgame.Lix.desktop" "$out/share/applications/lix.desktop"
    install -Dm644 "data/images/lix_logo.svg" "$out/share/icons/hicolor/scalable/apps/lix.svg"
    install -Dm644 "doc/copying.txt" "$out/share/licenses/lix/COPYING"
    install -Dm644 "doc/lix.6" "$out/share/man/man6/lix.6"

    # The program loads enet at runtime so we need to set LD_LIBRARY_PATH
    wrapProgram $out/bin/lix --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ enet ]}"
    runHook postInstall
  '';

  postInstall = ''
    remove-references-to -t ${ldc} $out/bin/lix
  '';

  meta = with lib; {
    description = "A puzzle game inspired by Lemmings";
    homepage = "https://www.lixgame.com/";
    license = licenses.cc0;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rampoina ];
  };
}
