{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
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
    version = "4.3.0";

    src = fetchFromGitHub {
      owner = "MicroPad";
      repo = "Micropad-Electron";
      rev = "v${version}";
      hash = "sha256-Rr3mOz2OlCq2tibxutR8zBANhswnkz70aP9BBS/pXp0=";
    };

    micropad-core = fetchzip {
      url = "https://github.com/MicroPad/MicroPad-Core/releases/download/v${version}/micropad.tar.xz";
      hash = "sha256-7yFTD8bXsxT6kBKxBGGxwzYpa0rZYLYV6KRYtImQ58c=";
    };

    packageJSON = ./package.json;

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/yarn.lock";
      hash = "sha256-PKCi1c8WY1BG/H1kUJ8xSCVoLF/9DEn5Kh29is2BTYY=";
    };

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
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

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

    passthru.updateScript = ./update.sh;

    meta = with lib; {
      description = "A powerful note-taking app that helps you organise + take notes without restrictions";
      homepage = "https://getmicropad.com/";
      license = licenses.mpl20;
      maintainers = with maintainers; [rhysmdnz];
      inherit (electron.meta) platforms;
    };
  }
