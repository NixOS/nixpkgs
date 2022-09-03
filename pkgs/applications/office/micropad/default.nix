{ lib
, stdenv
, fetchFromGitHub
, fetchzip
, makeWrapper
, makeDesktopItem
, mkYarnPackage
, electron
, desktopToDarwinBundle
, copyDesktopItems
}:
let
  executableName = "micropad";
in
  mkYarnPackage rec {
    pname = "micropad";
    version = "3.30.6";

    src = fetchFromGitHub {
      owner = "MicroPad";
      repo = "Micropad-Electron";
      rev = "v${version}";
      sha256 = "sha256-v3hnHG6FMW2xBU/DnenqjFizQv/OZ9cW99n/3SoENe8=";
    };

    micropad-core = fetchzip {
      url = "https://github.com/MicroPad/MicroPad-Core/releases/download/v${version}/micropad.tar.xz";
      hash = "sha256-aqshYbVrQg6tYtTlO91FGiH7DuueOA0OU5KGCVc7XvI=";
    };

    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;

    nativeBuildInputs = [ copyDesktopItems makeWrapper ]
      ++ lib.optionals stdenv.isDarwin [ desktopToDarwinBundle ];

    buildPhase = ''
      runHook preBuild
      pushd deps/micropad/
      yarn --offline build
      popd
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      # resources
      mkdir -p "$out/share/"
      cp -r './deps/micropad' "$out/share/micropad"
      ln -s '${micropad-core}' "$out/share/micropad/core"
      rm "$out/share/micropad/node_modules"
      cp -r './node_modules' "$out/share/micropad"

      # icons
      for icon in $out/share/micropad/build/icons/*.png; do
        mkdir -p "$out/share/icons/hicolor/$(basename $icon .png | sed -e 's/^icon-//')/apps"
        ln -s "$icon" "$out/share/icons/hicolor/$(basename $icon .png | sed -e 's/^icon-//')/apps/micropad.png"
      done

      # executable wrapper
      makeWrapper '${electron}/bin/electron' "$out/bin/${executableName}" \
        --add-flags "$out/share/micropad" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}"

      runHook postInstall
    '';

    # Do not attempt generating a tarball for micropad again.
    doDist = false;

    # The desktop item properties should be kept in sync with data from upstream:
    # https://github.com/MicroPad/MicroPad-Electron/blob/master/package.json
    desktopItems = [
      (makeDesktopItem {
        name = "micropad";
        exec = "${executableName} %u";
        icon = "micropad";
        desktopName = "µPad";
        startupWMClass = "µPad";
        comment = meta.description;
        categories = ["Office"];
      })
    ];

    meta = with lib; {
      description = "A powerful note-taking app that helps you organise + take notes without restrictions";
      homepage = "https://getmicropad.com/";
      license = licenses.mpl20;
      maintainers = with maintainers; [rhysmdnz];
      inherit (electron.meta) platforms;
    };
  }
