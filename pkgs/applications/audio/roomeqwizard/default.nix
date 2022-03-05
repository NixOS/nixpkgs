{ coreutils
, fetchurl
, gawk
, gnused
, jdk8
, lib
, makeDesktopItem
, makeWrapper
, stdenv
, writeScript
, writeTextFile
, recommendedUdevRules ? true
}:

stdenv.mkDerivation rec {
  pname = "roomeqwizard";
  version = "5.20.4";

  src = fetchurl {
    url = "https://www.roomeqwizard.com/installers/REW_linux_${lib.replaceChars [ "." ] [ "_" ] version}.sh";
    sha256 = "0m2b5hwazy4vyjk51cmayys250rircs3c0v7bv5mn28h7hyq29s8";
  };

  dontUnpack = true;

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    desktopName = "REW";
    genericName = "Software for audio measurements";
    categories = [ "AudioVideo" ];
  };

  responseFile = writeTextFile {
    name = "response.varfile";
    text = ''
      createDesktopLinkAction$Boolean=false
      executeLauncherAction$Boolean=false
      mem$Integer=1
      opengl$Boolean=false
      sys.adminRights$Boolean=false
      sys.installationDir=INSTALLDIR
      sys.languageId=en
      sys.programGroupDisabled$Boolean=true
    '';
  };

  udevRules = ''
    # MiniDSP UMIK-1 calibrated USB microphone
    SUBSYSTEM=="usb", ATTR{idVendor}=="2752", ATTR{idProduct}=="0007", TAG+="uaccess"
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild

    # set JDK path in installer
    sed -E 's|^#\s*(INSTALL4J_JAVA_HOME_OVERRIDE=)|\1${jdk8}|' $src > installer
    chmod +x installer

    sed -e "s|INSTALLDIR|$out/share/roomeqwizard|" $responseFile > response.varfile

    export HOME=$PWD

    ./installer -q -varfile response.varfile

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/udev/rules.d $out/share/icons/hicolor/256x256/apps
    makeWrapper $out/share/roomeqwizard/roomeqwizard $out/bin/roomeqwizard \
      --set INSTALL4J_JAVA_HOME_OVERRIDE ${jdk8} \
      --prefix PATH : ${lib.makeBinPath [ coreutils gnused gawk ]}

    cp -r "$desktopItem/share/applications" $out/share/
    cp $out/share/roomeqwizard/.install4j/s_*.png "$out/share/icons/hicolor/256x256/apps/${pname}.png"

    ${lib.optionalString recommendedUdevRules ''echo "$udevRules" > $out/lib/udev/rules.d/90-roomeqwizard.rules''}

    runHook postInstall
  '';

  passthru.updateScript = writeScript "${pname}-update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts nixpkgs-fmt coreutils perl

    set -euo pipefail

    perlexpr='if (/current version.{1,10}v(\d+)\.(\d+)\.(\d+)/i) { print "$1.$2.$3"; break; }'

    oldVersion="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion ${pname}" | tr -d '"')"
    latestVersion="$(curl -sS https://www.roomeqwizard.com/index.html | perl -ne "$perlexpr")"

    if [ ! "$oldVersion" = "$latestVersion" ]; then
      update-source-version ${pname} "$latestVersion" --version-key=version --print-changes
      nixpkgs-fmt "pkgs/applications/audio/roomeqwizard/default.nix"
    else
      echo "${pname} is already up-to-date"
    fi
  '';

  meta = with lib; {
    homepage = "https://www.roomeqwizard.com/";
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = with maintainers; [ zaninime ];
    description = "Room Acoustics Software";
    longDescription = ''
      REW is free software for room acoustic measurement, loudspeaker
      measurement and audio device measurement.
    '';
  };
}
