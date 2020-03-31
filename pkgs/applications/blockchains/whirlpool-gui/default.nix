{ stdenv, fetchFromGitHub, callPackage, makeWrapper, makeDesktopItem
, nodejs, yarn, fixup_yarn_lock, electron, jre, tor }:

with stdenv.lib;

let
  yarnOfflineCache = (callPackage ./deps.nix {}).offline_cache;

in stdenv.mkDerivation rec {
	name = "whirlpool-gui";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "Samourai-Wallet";
    repo = name;
    rev = version;
    sha256 = "ru6WJQRulhnQCPY2E0x9M6xXtFdj/pg2fu4HpQxhImU=";
  };

  nativeBuildInputs = [ makeWrapper fixup_yarn_lock nodejs yarn ];

  configurePhase = ''
    # Yarn and bundler wants a real home directory to write cache, config, etc to
    export HOME=$NIX_BUILD_TOP/fake_home

    # Make yarn install packages from our offline cache, not the registry
    yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}

    # Fixup "resolved"-entries in yarn.lock to match our offline cache
    fixup_yarn_lock yarn.lock

    # install build dependencies and patch shebangs
    yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/
  '';

  buildPhase = ''
    yarn build
  '';

  installPhase = ''
    mkdir -p $out/{bin,share,libexec/whirlpool-gui/app}

    # install production dependencies
    yarn install \
      --offline --frozen-lockfile --ignore-scripts \
      --no-progress --non-interactive \
      --production --no-bin-links \
      --modules-folder $out/libexec/whirlpool-gui/node_modules

    # copy application
    cp -r app/{dist,app.html,main.prod.js,main.prod.js.map,img} $out/libexec/whirlpool-gui/app
    cp -r package.json resources $out/libexec/whirlpool-gui

    # make desktop item
    ln -s "${desktopItem}/share/applications" "$out/share/applications"

    # wrap electron
    makeWrapper '${electron}/bin/electron' "$out/bin/whirlpool-gui" \
      --add-flags "$out/libexec/whirlpool-gui/app/main.prod.js" \
      --prefix PATH : "${jre}/bin:${tor}/bin"
  '';

  desktopItem = makeDesktopItem {
    name = "whirlpool-gui";
    exec = "whirlpool-gui";
    icon = "whirlpool-gui";
    desktopName = "Whirlpool";
    genericName = "Whirlpool";
    comment = meta.description;
    categories = "Network;";
    extraEntries = ''
      StartupWMClass=whrilpool-gui
    '';
  };

  meta = {
    description = "Desktop GUI for Whirlpool by Samourai-Wallet";
    homepage = https://www.samouraiwallet.com/whirlpool;
    license = licenses.unlicense;
    maintainers = [ maintainers.offine ];
    inherit (electron.meta) platforms;
  };
}
