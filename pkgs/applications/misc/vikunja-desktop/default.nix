{ lib
, makeWrapper, makeDesktopItem, mkYarnPackage, callPackage
, electron
, unstableGitUpdater
, fetchFromGitea
, fetchzip
, vikunja-frontend
}:

let
  executableName = "vikunja-desktop";
  version = "0.20.2";

  src = fetchFromGitea {
    domain = "kolaente.dev";
    owner = "vikunja";
    repo = "desktop";
    rev = "v${version}";
    sha256 = "sha256-xIQaqxibRlhmno3fzi8aqVmnVVE5lR0qhW74eWUzbgw=";
  };

in mkYarnPackage rec {
  name = "vikunja-desktop-${version}";
  inherit version src;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    # resources
    mkdir -p "$out/share/vikunja"
    cp -r './deps/vikunja-desktop' "$out/share/vikunja/electron"
    rm "$out/share/vikunja/electron/node_modules"
    cp -r './node_modules' "$out/share/vikunja/electron"
    ln -s '${vikunja-frontend}' "$out/share/vikunja/electron/frontend"

    # icons
    for icon in $out/share/vikunja/electron/build/icons/*.png; do
      mkdir -p "$out/share/icons/hicolor/$(basename $icon .png)/apps"
      ln -s "$icon" "$out/share/icons/hicolor/$(basename $icon .png)/apps/vikunja.png"
    done

    # desktop item
    mkdir -p "$out/share"
    ln -s "${desktopItem}/share/applications" "$out/share/applications"

    # executable wrapper
    makeWrapper '${electron}/bin/electron' "$out/bin/${executableName}" \
      --add-flags "$out/share/vikunja/electron"
  '';

  # Do not attempt generating a tarball for vikunja-frontend again.
  distPhase = ''
    true
  '';

  # The desktop item properties should be kept in sync with data from upstream:
  desktopItem = makeDesktopItem {
    name = "vikunja-desktop";
    exec = executableName;
    icon = "vikunja";
    desktopName = "Vikunja Desktop";
    genericName = "To-Do list app";
    comment = meta.description;
    categories = [ "ProjectManagement" "Office" ];
  };

  meta = with lib; {
    description = "Desktop App of the Vikunja to-do list app";
    homepage = "https://vikunja.io/";
    license = licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kolaente ];
    inherit (electron.meta) platforms;
  };

  passthru.updateScript = unstableGitUpdater {
    url = "${src.meta.homepage}.git";
  };
}

