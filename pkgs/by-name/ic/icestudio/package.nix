{
  lib,
  fetchurl,
  fetchFromGitHub,
  buildNpmPackage,
  makeDesktopItem,
  makeWrapper,

  nwjs,
  python3,
}:

let
  # Use unstable because it has improvements for finding python
  version = "0-unstable-2024-11-18";

  src = fetchFromGitHub {
    owner = "FPGAwars";
    repo = "icestudio";
    rev = "87d057adb1e795352a7dd67666a69ada4269b2e8";
    hash = "sha256-VZuc5Wa6o5PMUE+P4EMDl/pI/zmcff9OEhqeCfS4bzE=";
  };

  collection = fetchurl {
    url = "https://github.com/FPGAwars/collection-default/archive/v0.4.1.zip";
    hash = "sha256-F2cAqkTPC7xfGnPQiS8lTrD4y34EkHFUEDPVaYzVVg8=";
  };

  app = buildNpmPackage {
    pname = "icestudio-app";
    inherit version src;
    npmDepsHash = "sha256-CbrnhnhCG8AdAqySO6fB5hZ128lHyC3WH/vZcFtv6Ko=";
    sourceRoot = "${src.name}/app";
    dontNpmBuild = true;
    installPhase = ''
      cp -r . $out
    '';
  };

  desktopItem = makeDesktopItem {
    desktopName = "Icestudio";
    comment = "Visual editor for open FPGA boards";
    name = "icestudio";
    exec = "icestudio";
    icon = "icestudio";
    terminal = false;
    categories = [ "Development" ];
  };
in
buildNpmPackage rec {
  pname = "icestudio";
  inherit version src;
  npmDepsHash = "sha256-y1lo5+qJ6JBxjt7wtUmTHuJHMH9Mztf6xmmadI8zBgA=";
  npmFlags = [
    # Use the legacy dependency resolution, with less strict version
    # requirements for transative dependencies
    "--legacy-peer-deps"

    # We want to avoid call the scripts/postInstall.sh until we copy the
    # collection and app derivation we do that on installPhase
    "--ignore-scripts"
  ];

  buildPhase = ''
    runHook preBuild

    # Copy the `app` derivation into the folder expected for grunt
    cp -r ${app}/* app

    # Copy the cached `collection` derivation into the cache location so that
    # grunt avoids downloading it
    install -m444 -D ${collection} cache/collection/collection-default.zip

    ./node_modules/.bin/grunt getcollection

    # Use grunt to distribute package
    # TODO: support aarch64
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

    install -Dm644 ${desktopItem}/share/applications/icestudio.desktop -t $out/share/applications

    makeWrapper ${nwjs}/bin/nw $out/bin/${pname} \
        --add-flags $out \
        --prefix PATH : "${python3}/bin"

    runHook postInstall
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ python3 ];

  meta = {
    description = "Visual editor for open FPGA boards";
    homepage = "https://github.com/FPGAwars/icestudio/";
    license = lib.licenses.gpl2Only;
    maintainers =
      with lib.maintainers;
      [
        kiike
        jleightcap
        rcoeurjoly
        amerino
      ]
      ++ [ lib.teams.ngi ];
    mainProgram = "icestudio";
    platforms = lib.platforms.linux;
  };
}
