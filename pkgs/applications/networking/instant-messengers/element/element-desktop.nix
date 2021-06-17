{ lib, fetchFromGitHub
, makeWrapper, makeDesktopItem, mkYarnPackage
, electron, element-web
, python3, sqlcipher, rustc, cargo, pkg-config, libsecret, yarn
, rustPlatform, callPackage
}:
# Notes for maintainers:
# * versions of `element-web` and `element-desktop` should be kept in sync.
# * the Yarn dependency expression must be updated with `./update-element-desktop.sh <git release tag>`

let
  executableName = "element-desktop";
  version = "1.7.30";
  src = fetchFromGitHub {
    owner = "vector-im";
    repo = "element-desktop";
    rev = "v${version}";
    sha256 = "09k1xxmzqvw8c1x9ndsdvwj4598rdx9zqraz3rmr3i58s51vycxp";
  };
in mkYarnPackage rec {
  name = "element-desktop-${version}";
  inherit version src;

  packageJSON = ./element-desktop-package.json;
  yarnLock = ./element-desktop-yarn.lock;
  yarnNix = ./element-desktop-yarndeps.nix;

  nativeBuildInputs = [
    makeWrapper
    python3 rustc cargo rustPlatform.cargoSetupHook pkg-config yarn
    sqlcipher libsecret # FIXME this should be in buildInputs
  ];

  postPatch = let
    inherit ((lib.importJSON packageJSON).build) electronVersion;
  in ''
    cargoRoot=../..$node_modules/matrix-seshat/native

    export HOME=/tmp
    mkdir -p $HOME/.electron-gyp/${electronVersion}
    tar -x -C $HOME/.electron-gyp/${electronVersion} --strip-components=1 -f ${electron.headers}
    echo 9 > $HOME/.electron-gyp/${electronVersion}/installVersion
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    src = (lib.findFirst (x: lib.hasPrefix "matrix_seshat" x.name) null (callPackage yarnNix {}).packages).path;
    sourceRoot = "package/native";
    name = "sesha-cargo-deps";
    sha256 = "1f6hsw6rafs3hnqhrm135and0vrqy0qbda43bgcl4587sz1gzxm7";
  };

  preBuild = ''
    hak_modules=$(ls deps/element-desktop/hak)
    (
      cd deps/element-desktop

      node scripts/hak/index.js check

      mkdir -p .hak/hakModules
      for hak_module in $hak_modules
      do
        mkdir -p .hak/$hak_module
        cp -r $node_modules/$hak_module .hak/$hak_module/build
        chmod u+w -R .hak/$hak_module/build
        cp -r $node_modules/$hak_module .hak/hakModules/$hak_module
        chmod u+w -R .hak/hakModules/$hak_module
        rm -rf .hak/$hak_module/build/node_modules
        ln -s $node_modules .hak/$hak_module/build/node_modules
      done

      node scripts/hak/index.js build
      node scripts/hak/index.js copy

      for hak_module in $hak_modules
      do
        rm -rf .hak/$hak_module
      done

      mv .hak/hakModules ../..
      rm -rf .hak
    )
  '';

  installPhase = ''
    # resources
    mkdir -p "$out/share/element"
    ln -s '${element-web}' "$out/share/element/webapp"
    cp -r './deps/element-desktop' "$out/share/element/electron"
    cp -r './deps/element-desktop/res/img' "$out/share/element"
    rm "$out/share/element/electron/node_modules"
    cp -r './node_modules' "$out/share/element/electron"

    # native modules
    for hak_module in $hak_modules
    do
      rm -rf $out/share/element/electron/node_modules/$hak_module
      mv hakModules/$hak_module $out/share/element/electron/node_modules
    done

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
  # https://github.com/vector-im/element-desktop/blob/develop/package.json
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

  meta = with lib; {
    description = "A feature-rich client for Matrix.org";
    homepage = "https://element.io/";
    changelog = "https://github.com/vector-im/element-desktop/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = teams.matrix.members;
    inherit (electron.meta) platforms;
  };
}
