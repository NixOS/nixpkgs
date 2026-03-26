{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  fetchzip,
  jre,
  makeWrapper,
  imagemagick,
  openal,
  portaudio,
  copyDesktopItems,
  makeDesktopItem,
  cmake,
  writeScript,
  desktopToDarwinBundle,
}:

let
  jre' = jre.override { enableJavaFX = true; };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "beatoraja-bin";
  version = "0.8.8";

  src = fetchzip {
    url = "https://mocha-repository.info/download/beatoraja${finalAttrs.version}-modernchic.zip";
    hash = "sha256-TujfJ7hgjEKs5NbGvwo3/nkbJFvcZ4mefgkdp6oQHw4=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    imagemagick
  ]
  ++ lib.optional stdenvNoCC.hostPlatform.isDarwin desktopToDarwinBundle;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/beatoraja
    cp -r * $out/share/beatoraja

    rm $out/share/beatoraja/*.{bat,dll,command}
    rm -r $out/share/beatoraja/manual

    makeWrapper ${lib.getExe jre'} $out/bin/beatoraja \
      --add-flags -Xms1g \
      --add-flags -Xmx4g \
      --add-flags -Dsun.java2d.opengl=true \
      --add-flags -Dawt.useSystemAAFontSettings=on \
      --add-flags -Dswing.aatext=true \
      --add-flags -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel \
      --add-flags -jar \
      --add-flags $out/share/beatoraja/beatoraja.jar \
      --prefix ${if stdenvNoCC.hostPlatform.isDarwin then "DY" else ""}LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          openal
          finalAttrs.passthru.jportaudio
        ]
      } \
      --run "out=$out; $(cat ${./launcher.sh})"

    # the upstream does not have a canonical icon, but this picture is iconic for modernchic, so it should be appropriate
    for size in 16 32 48 64 128 144; do
      mkdir -p $out/share/icons/hicolor/''${size}x$size/apps
      magick skin/ModernChic/Result/parts/char/isclear/clear/yuki.png \
        -crop 144x144+895+350 \
        -resize ''${size}x$size \
        $out/share/icons/hicolor/''${size}x$size/apps/beatoraja.png
    done

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "beatoraja";
      comment = finalAttrs.meta.description;
      desktopName = "beatoraja";
      exec = "beatoraja %U";
      icon = "beatoraja";
      startupWMClass = "bms.player.beatoraja.MainLoader";
      categories = [ "Game" ];
    })
  ];

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts

    set -euo pipefail

    update-source-version beatoraja-bin $(grep -Eo '[0-9]+\.[0-9]+\.[0-9]' <(curl -s 'https://mocha-repository.info/download.php') | head -n 1)

    response=$(curl ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL "https://api.github.com/repos/philburk/portaudio-java/commits?per_page=1")
    rev=$(echo "$response" | jq -r '.[0].sha')
    date=$(echo "$response" | jq -r '.[0].commit.committer.date' | cut -c1-10)
    update-source-version beatoraja-bin.passthru.jportaudio 0-unstable-$date --rev=$rev
  '';

  passthru.jportaudio = stdenv.mkDerivation (finalAttrs: {
    pname = "jportaudio";
    version = "0-unstable-2026-02-13";

    src = fetchFromGitHub {
      owner = "philburk";
      repo = "portaudio-java";
      rev = "d185a5322ecbe8bd209e14e7341fb73d0c7d2cc3";
      hash = "sha256-XG1bJm0hDSF4cE2OvQ5bvN8pmaKwIl9zDlsRCnTXnLc=";
    };

    nativeBuildInputs = [ cmake ];

    buildInputs = [
      jre'
      portaudio
    ];

    postInstall = ''
      # the jportaudio library bundled in beatoraja looks for libjportaudio.so instead
      ln -s $out/lib/libjportaudio_0_1_0.so $out/lib/libjportaudio.so
    '';

    meta = {
      description = "Java wrapper for the PortAudio audio library";
      homepage = "https://github.com/philburk/portaudio-java";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ ulysseszhan ];
    };
  });

  meta = {
    description = "Cross-platform rhythm game based on Java and libGDX";
    homepage = "https://mocha-repository.info";
    downloadPage = "https://mocha-repository.info/download.php";
    license = with lib.licenses; [
      gpl3Only
      unfree # ModernChic
    ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "x86_64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    mainProgram = "beatoraja";
  };
})
