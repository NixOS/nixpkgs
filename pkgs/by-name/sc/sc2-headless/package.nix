{
  config,
  stdenv,
  callPackage,
  lib,
  fetchurl,
  unzip,
  licenseAccepted ? config.sc2-headless.accept_license or false,
}:

let
  maps = callPackage ./maps.nix { inherit licenseAccepted; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sc2-headless";
  # Last Linux package Blizzard published.
  version = "4.10";

  src = fetchurl {
    url = "https://blzdistsc2-a.akamaihd.net/Linux/SC2.${finalAttrs.version}.zip";
    hash = "sha256-EFLySfMKJCv14XzDMVMkkZ+WiTB8ptvNswu0HqMASIQ=";
  };

  unpackCmd =
    if !licenseAccepted then
      throw ''
        You must accept the Blizzard® Starcraft® II AI and Machine Learning License at
        https://blzdistsc2-a.akamaihd.net/AI_AND_MACHINE_LEARNING_LICENSE.html
        by setting nixpkgs config option 'sc2-headless.accept_license = true;'
      ''
    else
      assert licenseAccepted;
      ''
        # Info-ZIP cannot inflate the empty Cache/TMP entries; skip them.
        unzip -P 'iagreetotheeula' "$curSrc" -x 'StarCraftII/Battle.net/Cache/TMP/*'
      '';

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out
    cp -r . "$out"
    rm -r $out/Libs

    cp -ur "${maps.minigames}"/* "${maps.melee}"/* "${maps.ladder2017season1}"/* "${maps.ladder2017season2}"/* "${maps.ladder2017season3}"/* \
      "${maps.ladder2017season4}"/* "${maps.ladder2018season1}"/* "${maps.ladder2018season2}"/* \
      "${maps.ladder2018season3}"/*  "${maps.ladder2018season4}"/* "${maps.ladder2019season1}"/* "$out"/Maps/
  '';

  preFixup = ''
    find $out -type f -print0 | while IFS=''' read -d ''' -r file; do
      isELF "$file" || continue
      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath ${
          lib.makeLibraryPath [
            stdenv.cc.cc
            stdenv.cc.libc
          ]
        } \
        "$file"
    done
  '';

  meta = {
    platforms = lib.platforms.linux;
    description = "Starcraft II headless linux client for machine learning research";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = {
      fullName = "BLIZZARD® STARCRAFT® II AI AND MACHINE LEARNING LICENSE";
      url = "https://blzdistsc2-a.akamaihd.net/AI_AND_MACHINE_LEARNING_LICENSE.html";
      free = false;
    };
    maintainers = [ ];
  };
})
