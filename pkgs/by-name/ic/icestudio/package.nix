{
  lib,
  fetchurl,
  fetchFromGitHub,
  buildNpmPackage,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  unstableGitUpdater,

  nwjs,
  python3,
}:

buildNpmPackage (finalAttrs: {
  pname = "icestudio";
  version = "1.0.0.PRw-20260821-unstable-2026-08-20";

  src = fetchFromGitHub {
    owner = "FPGAwars";
    repo = "icestudio";
    rev = "989c552b687993f54a5928f693e3502de02e29f8";
    hash = "sha256-GTsLt3IgqXCkGJZGmvWslHL8gqm/0tnRJWlceV64asA=";
  };

  npmDepsHash = "sha256-4B5dpU7LV/2ga7gbu/TdwOYZL/HDm4fi9TXNcZEyeOI=";
  npmFlags = [
    # Use the legacy dependency resolution, with less strict version
    # requirements for transative dependencies
    "--legacy-peer-deps"

    # We want to avoid call the scripts/postInstall.sh until we copy the
    # collection and app derivation we do that on installPhase
    "--ignore-scripts"
  ];

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    python3
  ];

  buildPhase = ''
    runHook preBuild

    # Copy the `app` derivation into the folder expected for grunt
    cp -r ${finalAttrs.passthru.app}/* app

    # Copy the cached `collection` derivation into the cache location so that
    # grunt avoids downloading it
    install -m444 -D ${finalAttrs.passthru.collection} cache/collection/collection-default.zip

    # Use grunt to distribute package
    ./node_modules/.bin/grunt dist \
        --platform=none    `# skip platform-specific steps` \
        --dont-build-nwjs  `# use the nwjs package shipped by Nix` \
        --dont-clean-tmp   `# skip cleaning the tmp folder as we'll use it in $out`

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist/tmp $out

    for size in 16 32 64 128 256; do
      install -Dm644 docs/resources/icons/"$size"x"$size"/apps/icon.png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/icestudio.png
    done

    makeWrapper ${nwjs}/bin/nw $out/bin/icestudio \
        --add-flags $out \
        --prefix PATH : "${python3}/bin"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Icestudio";
      comment = "Visual editor for open FPGA boards";
      name = "icestudio";
      exec = "icestudio";
      icon = "icestudio";
      terminal = false;
      categories = [ "Development" ];
    })
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
    };

    collection = fetchurl {
      url = "https://github.com/FPGAwars/collection-default/archive/v0.4.1.zip";
      hash = "sha256-F2cAqkTPC7xfGnPQiS8lTrD4y34EkHFUEDPVaYzVVg8=";
    };

    app = buildNpmPackage {
      pname = "icestudio-app";
      inherit (finalAttrs) version src;
      npmDepsHash = "sha256-twDndqYV+aXtkcBC/jnZCJ0p9L24AgRORz4yDTledH0=";
      sourceRoot = "${finalAttrs.src.name}/app";
      dontNpmBuild = true;
      installPhase = ''
        cp -r . $out
      '';
    };
  };

  meta = {
    description = "Visual editor for open FPGA boards";
    homepage = "https://github.com/FPGAwars/icestudio/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      kiike
      jleightcap
      rcoeurjoly
      amerino
    ];
    teams = [ lib.teams.ngi ];
    mainProgram = "icestudio";
    platforms = lib.platforms.linux;
  };
})
