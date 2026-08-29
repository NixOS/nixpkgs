{
  lib,
  stdenv,

  autoPatchelfHook,
  buildFHSEnv,
  fetchurl,
  zstd,

  digilent-adept,
  pipewire,
  qt6,
}:
let
  version = "3.25.1";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://files.digilent.com/Software/Waveforms/${version}/digilent.waveforms_${version}_amd64.deb";
      hash = "sha256-0peaq3JskgKkihxdKzFFMVExccC2L6Lyou3NKSAnJ9M=";
    };

    aarch64-linux = fetchurl {
      url = "https://files.digilent.com/Software/Waveforms/${version}/digilent.waveforms_${version}_arm64.deb";
      hash = "sha256-FP/EUD9znoepV+82P5lPVE5Jt33sxOPvS7ysODLIA0U=";
    };
  };

  package = stdenv.mkDerivation (finalAttrs: {
    pname = "digilent-waveforms";
    inherit version;

    src =
      srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

    strictDeps = true;

    nativeBuildInputs = [
      autoPatchelfHook
      qt6.wrapQtAppsHook
      zstd
    ];

    buildInputs = [
      digilent-adept
      qt6.qtbase
      qt6.qtconnectivity
      qt6.qtdeclarative
      qt6.qtmultimedia
      qt6.qtserialport
    ];

    unpackPhase = ''
      runHook preUnpack

      ar x $src
      tar -xf data.tar.*

      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"/{bin,lib,share}

      cp -r usr/bin/. "$out/bin/"
      cp -r usr/lib/. "$out/lib/"
      cp -r usr/share/. "$out/share/"

      substituteInPlace "$out/share/applications/digilent.waveforms.desktop" \
        --replace-fail "Exec=/usr/bin/waveforms %u" "Exec=digilent-waveforms %u"

      runHook postInstall
    '';

    meta = {
      description = "Virtual instrument suite for Digilent Test and Measurement devices";
      downloadPage = "https://cloud.digilent.com/myproducts/waveforms";
      homepage = "https://digilent.com/reference/software/waveforms/waveforms-3/start";
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers; [ iJustLeyxo ];
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  });
in
buildFHSEnv {
  inherit (package) pname version meta;

  targetPkgs = pkgs: [
    digilent-adept
    pipewire

    package
  ];

  runScript = "${package.outPath}/bin/waveforms";

  extraInstallCommands = ''
    mkdir -p "$out/share"/{applications,icons}
    ln -sf "${package.outPath}/share/applications/"* "$out/share/applications/"
    ln -sf "${package.outPath}/share/digilent/waveforms/pixmaps/256.png" "$out/share/icons/waveforms.png"
  '';
}
