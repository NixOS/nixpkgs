{ pkgs, stdenv, fetchFromGitHub, makeWrapper, makeDesktopItem, electron, riot-web }:

# Note for maintainers:
# Versions of `riot-web` and `riot-desktop` should be kept in sync.

with (import ./yarn2nix.nix { inherit pkgs; });

let
  executableName = "riot-desktop";
  version = "1.0.8";
  riot-web-src = fetchFromGitHub {
    owner = "vector-im";
    repo = "riot-web";
    rev = "v${version}";
    sha256 = "1krp608wxff1siih8zknc425n0qb6qjzf854fnp7qyjp1cnfc9sb";
  };

in mkYarnPackage rec {
  name = "riot-desktop-${version}";
  inherit version;

  src = "${riot-web-src}/electron_app";

  # The package manifest should be copied on each update of this package.
  # > cp ${riot-web-src}/electron_app/package.json riot-desktop-package.json
  packageJSON = ./riot-desktop-package.json;

  # The dependency expression can be regenerated using nixos.yarn2nix with the following command:
  # > yarn2nix --lockfile=${riot-web-src}/electron_app/yarn.lock > riot-desktop-yarndeps.nix
  yarnNix = ./riot-desktop-yarndeps.nix;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    # resources
    mkdir -p "$out/share/riot"
    ln -s '${riot-web}' "$out/share/riot/webapp"
    cp -r '${riot-web-src}/origin_migrator' "$out/share/riot/origin_migrator"
    cp -r '.' "$out/share/riot/electron"

    # icons
    for icon in $out/share/riot/electron/build/icons/*.png; do
      mkdir -p "$out/share/icons/hicolor/$(basename $icon .png)/apps"
      ln -s "$icon" "$out/share/icons/hicolor/$(basename $icon .png)/apps/riot.png"
    done

    # desktop item
    mkdir -p "$out/share"
    ln -s "${desktopItem}/share/applications" "$out/share/applications"

    # executable wrapper
    makeWrapper '${electron}/bin/electron' "$out/bin/${executableName}" \
      --add-flags "$out/share/riot/electron"
  '';

  # Do not attempt generating a tarball for riot-web again.
  # note: `doDist = false;` does not work.
  distPhase = ''
    true
  '';

  # The desktop item properties should be kept in sync with data from upstream:
  # * productName and description from
  #   https://github.com/vector-im/riot-web/blob/develop/electron_app/package.json
  # * category and StartupWMClass from the build.linux section of
  #   https://github.com/vector-im/riot-web/blob/develop/package.json
  desktopItem = makeDesktopItem {
    inherit name;
    exec = executableName;
    icon = "riot";
    desktopName = "Riot";
    genericName = "Matrix Client";
    comment = meta.description;
    categories = "Network;InstantMessaging;Chat;";
    extraEntries = ''
      StartupWMClass="riot"
    '';
  };

  meta = with stdenv.lib; {
    description = "A feature-rich client for Matrix.org";
    homepage = https://about.riot.im/;
    license = licenses.asl20;
    maintainers = with maintainers; [ pacien ];
    inherit (electron.meta) platforms;
  };
}

