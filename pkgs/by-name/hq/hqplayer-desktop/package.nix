{
  alsa-lib,
  autoPatchelfHook,
  dpkg,
  evince,
  fetchurl,
  flac,
  gccForLibs,
  imagemagick,
  kdePackages,
  lib,
  libmicrohttpd,
  libogg,
  libusb-compat-0_1,
  llvmPackages,
  mpfr,
  stdenvNoCC,
  undmg,
  wavpack,
}:

let
  latestDebianCodename = "trixie";
  latestUbuntuCodename = "noble";
  version = "6.0.2-3";
  majorVersion = lib.versions.major version;
  compactVersion = with lib.versions; "${major version}${minor version}${patch version}";
  srcs = {
    aarch64-linux = fetchurl {
      url = "https://signalyst.com/bins/${latestDebianCodename}/hqplayer${majorVersion}desktop_${version}_arm64.deb";
      hash = "sha256-remml9wtBrJXiSA96rBjf0tbVJquskq2o+kmeAxI84M=";
    };
    x86_64-linux = fetchurl {
      url = "https://signalyst.com/bins/${latestUbuntuCodename}/hqplayer${majorVersion}desktop_${version}_amd64.deb";
      hash = "sha256-Lx0E7lM7lLl44s7+T17JJmjKzdKmXJbD5iXDBJelT24=";
    };
    aarch64-darwin = fetchurl {
      url = "https://signalyst.com/bins/HQPlayer${majorVersion}Desktop-arm64-${compactVersion}.dmg";
      hash = "sha256-H2F75NltbzfxC/zrVwMKALvx2ar+S0is0Nk8lsRx+Fc=";
    };
  };
in
stdenvNoCC.mkDerivation (
  {
    pname = "hqplayer-desktop";
    inherit version;

    src = with stdenvNoCC.hostPlatform; srcs.${system} or (throw "Unsupported system: ${system}");

    meta = {
      homepage = "https://www.signalyst.com";
      description = "High-end upsampling multichannel software HD-audio player";
      license = lib.licenses.unfree;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      platforms = builtins.attrNames srcs;
      maintainers = with lib.maintainers; [
        lovesegfault
        yiyu
      ];
    };
  }
  // (
    if stdenvNoCC.hostPlatform.isDarwin then
      {
        nativeBuildInputs = [ undmg ];

        setSourceRoot = ''
          sourceRoot=HQPlayer${majorVersion}Desktop.app
        '';

        installPhase = ''
          runHook preInstall

          mkdir --parents "$out"/Applications
          cp --recursive . "$_"/"$sourceRoot"

          runHook postInstall
        '';
      }
    else
      {
        nativeBuildInputs = [
          autoPatchelfHook
          dpkg
          imagemagick
          kdePackages.wrapQtAppsHook
        ];

        buildInputs = [
          alsa-lib
          flac
          libmicrohttpd
          libogg
          libusb-compat-0_1
          llvmPackages.openmp
          mpfr
          gccForLibs
          wavpack
        ]
        ++ (with kdePackages; [
          qtcharts
          qtdeclarative
          qtwayland
          qtwebengine
          qtwebview
        ]);

        # doc has dependencies on evince that is not required by main app
        outputs = [
          "out"
          "doc"
        ];

        installPhase = ''
          runHook preInstall

          install -D usr/bin/* --target-directory="$out"/bin

          # The binary links against libomp.so.5, which is not provided by
          # `llvmPackages.openmp`; provide it as a symlink so that
          # `autoPatchelfHook` can resolve it.
          mkdir -p "$out"/lib
          ln --symbolic \
            ${lib.getLib llvmPackages.openmp}/lib/libomp.so \
            "$out"/lib/libomp.so.5
          addAutoPatchelfSearchPath "$out"/lib

          # documentation
          install -Dm644 usr/share/doc/hqplayer${majorVersion}desktop/* \
            --target-directory="$doc"/share/doc/hqplayer-desktop
          gunzip "$doc"/share/doc/hqplayer-desktop/*.gz
          install -Dm644 \
            usr/share/applications/hqplayer${majorVersion}desktop-manual.desktop \
            --target-directory="$doc"/share/applications

          # desktop files
          install -Dm644 usr/share/applications/* \
            --target-directory="$out"/share/applications

          # icons
          install -Dm644 usr/share/pixmaps/hqplayer${majorVersion}{client,desktop}.png \
            --target-directory="$out"/share/icons/hicolor/128x128/apps
          mkdir --parents "$out"/share/icons/hicolor/96x96/apps
          magick mogrify -path "$_" -resize 96x96 \
            usr/share/pixmaps/hqplayer${majorVersion}desktop-manual.png

          for desktopFile in \
            "$out"/share/applications/hqplayer${majorVersion}{client,desktop}.desktop; do
            substituteInPlace "$desktopFile" \
              --replace-fail /usr/bin "$out"/bin
          done

          substituteInPlace "$doc"/share/applications/hqplayer${majorVersion}desktop-manual.desktop \
            --replace-fail /usr/share/doc/hqplayer${majorVersion}desktop "$doc"/share/doc/hqplayer-desktop \
            --replace-fail .pdf.gz .pdf \
            --replace-fail evince ${lib.getExe evince}

          runHook postInstall
        '';
      }
  )
)
