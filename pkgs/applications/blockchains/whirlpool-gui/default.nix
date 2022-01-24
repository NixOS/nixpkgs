{ lib, stdenv, fetchFromGitHub, callPackage, makeWrapper, makeDesktopItem
, nodejs, yarn, electron_7, jre8, tor }:

let
  system = stdenv.hostPlatform.system;
  electron = electron_7;

in stdenv.mkDerivation rec {
  pname = "whirlpool-gui";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "Samourai-Wallet";
    repo = pname;
    rev = version;
    sha256 = "ru6WJQRulhnQCPY2E0x9M6xXtFdj/pg2fu4HpQxhImU=";
  };

  yarnCache = stdenv.mkDerivation {
    name = "${pname}-${version}-${system}-yarn-cache";
    inherit src;
    dontInstall = true;
    nativeBuildInputs = [ yarn ];
    buildPhase = ''
      export HOME=$NIX_BUILD_ROOT

      yarn config set yarn-offline-mirror $out
      yarn --frozen-lockfile --ignore-scripts --ignore-platform \
        --ignore-engines --no-progress --non-interactive
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = {
      x86_64-linux = "6fl4cSwHXWgQcYlqxCae0p1Ppcb9fI5fFrxm7y6wxTo=";
    }.${system} or (throw "Unsupported platform ${system}");
  };

  nativeBuildInputs = [ makeWrapper nodejs yarn ];

  configurePhase = ''
    # Yarn and bundler wants a real home directory to write cache, config, etc to
    export HOME=$NIX_BUILD_ROOT

    # Make yarn install packages from our offline cache, not the registry
    yarn config --offline set yarn-offline-mirror ${yarnCache}
  '';

  buildPhase = ''
    yarn install --offline --ignore-scripts --frozen-lockfile --no-progress --non-interactive

    patchShebangs node_modules/

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
      --add-flags "$out/libexec/whirlpool-gui" \
      --prefix PATH : "${jre8}/bin:${tor}/bin"
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

  passthru.prefetchYarnCache = lib.overrideDerivation yarnCache (d: {
    outputHash = lib.fakeSha256;
  });

  meta = with lib; {
    description = "Desktop GUI for Whirlpool by Samourai-Wallet";
    homepage = "https://www.samouraiwallet.com/whirlpool";
    license = licenses.unlicense;
    maintainers = [ maintainers.offline ];
    platforms = [ "x86_64-linux" ];
  };
}
