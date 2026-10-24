{
  lib,
  stdenv,
  nix-update-script,
  fetchFromGitHub,
  copyDesktopItems,
  imagemagick,
  makeDesktopItem,
  jdk,
  ant,
  stripJavaArchivesHook,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crg-scoreboard";
  version = "2027.0";
  # CRG requires its data to be writable
  dataDirectory = "\\$HOME/.local/share/crg-scoreboard";

  src = fetchFromGitHub {
    owner = "rollerderby";
    repo = "scoreboard";
    tag = finalAttrs.version;
    sha256 = "sha256-SroUEBPBQS1tIya9YfIKReXb9Rmo9eSjLZZ8NbsMp5w=";
  };

  nativeBuildInputs = [
    ant
    jdk
    stripJavaArchivesHook
    copyDesktopItems
    imagemagick
  ];

  buildInputs = [
    jdk
    bash
  ];

  strictDeps = true;
  __structuredAttrs = true;

  # Patch version instead of relying on git
  # Also patch for output to be reproducible
  postPatch = ''
    substituteInPlace ./build.xml \
      --replace-fail "executable=\"git\"" "executable=\"echo\"" \
      --replace-fail "describe --tags --always --dirty" "${finalAttrs.version}" \
      --replace-fail "describe --exclude * --always --abbrev=100" "" \
      --replace-fail "<hostinfo prefix=\"host\"/>" "" \
      --replace-fail "\''${user.name}" "" \
      --replace-fail "\''${host.NAME}" "" \
      --replace-fail "</propertyfile>" "</propertyfile><replaceregexp file=\"\''${version.dest.dir}/\''${version.release.file}\" match=\"^#.*\n\" replace=\"\"/>"
  '';

  buildPhase = ''
    runHook preBuild
    ant clean compile
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    # Install runtime files to $out
    mkdir -p $out/bin $out/share/crg-scoreboard $out/share/crg-scoreboard/data/
    install -Dm644 ./lib/crg-scoreboard.jar $out/share/crg-scoreboard
    cp -rv ./config $out/share/crg-scoreboard/data/config
    cp -rv ./html $out/share/crg-scoreboard/data/html
    cp -v ./start.html $out/share/crg-scoreboard/data/start.html

    # Generate desktop icon
    for RES in 16 24 32 48 64 128 256; do
      mkdir -p $out/share/icons/hicolor/"$RES"x"$RES"/apps
      magick ./html/favicon.ico -resize "$RES"x"$RES" $out/share/icons/hicolor/"$RES"x"$RES"/apps/crg-scoreboard.png
    done
    magick ./html/favicon.ico -resize 128x128 $out/share/icons/crg-scoreboard.png

    # Bash script sourced from scoreboard.sh
    cat << EOS > $out/bin/crg-scoreboard
    #!${bash}/bin/bash
    DATA="${finalAttrs.dataDirectory}"
    if [ ! -d \$DATA ]; then
      mkdir -p \$DATA
      cp -rv --no-preserve=mode,ownership $out/share/crg-scoreboard/data/* \$DATA
    fi
    cd \$DATA
    echo Data will be saved in \$DATA.
    GUI="--gui"
    test -t "0" && GUI=""
    exec ${jdk}/bin/java -Done-jar.silent=true -Dorg.eclipse.jetty.server.LEVEL=WARN -jar $out/share/crg-scoreboard/crg-scoreboard.jar "\$GUI" "\$@"
    EOS

    chmod +x $out/bin/crg-scoreboard
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "crg-scoreboard";
      exec = "crg-scoreboard %U";
      icon = "crg-scoreboard";
      desktopName = "CRG Derby Scoreboard";
      genericName = "Roller Derby Scoreboard";
      comment = "Carolina Roller Girls - Derby Scoreboard";
      categories = [ "Utility" ];
      keywords = [
        "Carolina"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The CRG (Carolina Roller Girls) ScoreBoard is a browser-based scoreboard solution that also provides overlays for video production and the ability to track full game data and export it to a WFTDA statsbook.";
    homepage = "https://github.com/rollerderby/scoreboard/";
    changelog = "https://github.com/rollerderby/scoreboard/releases/tag/${finalAttrs.version}";
    license =
      with lib.licenses;
      OR [
        gpl3Plus
        asl20
      ];
    maintainers = with lib.maintainers; [ tgi74 ];
    platforms = lib.platforms.linux;
    mainProgram = "crg-scoreboard";
  };
})
