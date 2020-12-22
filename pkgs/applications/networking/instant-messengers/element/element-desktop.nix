{ stdenv, fetchFromGitHub
, makeWrapper, makeDesktopItem, mkYarnPackage
, electron_9, element-web
}:
# Notes for maintainers:
# * versions of `element-web` and `element-desktop` should be kept in sync.
# * the Yarn dependency expression must be updated with `./update-element-desktop.sh <git release tag>`

let
  executableName = "element-desktop";
  version = "1.7.16";
  src = fetchFromGitHub {
    owner = "vector-im";
    repo = "element-desktop";
    rev = "v${version}";
    sha256 = "sha256-mdHsw1Vi+2hrAF7biX3pJqfRaZU2lpw9zUZdcCm717g=";
  };
  electron = electron_9;

in mkYarnPackage rec {
  name = "element-desktop-${version}";
  inherit version src;

  packageJSON = ./element-desktop-package.json;
  yarnNix = ./element-desktop-yarndeps.nix;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    # resources
    mkdir -p "$out/share/element"
    ln -s '${element-web}' "$out/share/element/webapp"
    cp -r './deps/element-desktop' "$out/share/element/electron"
    cp -r './deps/element-desktop/res/img' "$out/share/element"
    rm "$out/share/element/electron/node_modules"
    cp -r './node_modules' "$out/share/element/electron"

    # icons
    for icon in $out/share/element/electron/build/icons/*.png; do
      mkdir -p "$out/share/icons/hicolor/$(basename $icon .png)/apps"
      ln -s "$icon" "$out/share/icons/hicolor/$(basename $icon .png)/apps/element.png"
    done

    # desktop item
    mkdir -p "$out/share"
    ln -s "${desktopItem}/share/applications" "$out/share/applications"

    # executable wrapper
    makeWrapper '${electron}/bin/electron' "$out/bin/${executableName}" \
      --add-flags "$out/share/element/electron"
  '';

  # Do not attempt generating a tarball for element-web again.
  # note: `doDist = false;` does not work.
  distPhase = ''
    true
  '';

  # The desktop item properties should be kept in sync with data from upstream:
  # https://github.com/vector-im/riot-desktop/blob/develop/package.json
  desktopItem = makeDesktopItem {
    name = "element-desktop";
    exec = "${executableName} %u";
    icon = "element";
    desktopName = "Element (Riot)";
    genericName = "Matrix Client";
    comment = meta.description;
    categories = "Network;InstantMessaging;Chat;";
    extraEntries = ''
      StartupWMClass=element
      MimeType=x-scheme-handler/element;
    '';
  };

  meta = with stdenv.lib; {
    description = "A feature-rich client for Matrix.org";
    homepage = "https://element.io/";
    license = licenses.asl20;
    maintainers = teams.matrix.members;
    inherit (electron.meta) platforms;
  };
}
