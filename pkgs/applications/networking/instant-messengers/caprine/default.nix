{ stdenv, pkgs, nodejs, makeDesktopItem, makeWrapper, electron }:

let
  packageName = with stdenv.lib;
    head
      (map
        (entry: "caprine-${entry.caprine}")
        (filter
          (entry: hasAttr "caprine" entry)
          (importJSON ./node-packages.json)));

  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

  desktopItem = makeDesktopItem {
    name = "caprine";
    exec = "caprine";
    icon = "caprine";
    desktopName = "Caprine";
    genericName = "IM Client";
    comment = "Elegant Facebook Messenger desktop app";
    categories = "GTK;InstantMessaging;Network;";
    startupNotify = "true";
  };
in nodePackages.${packageName}.override {
  nativeBuildInputs = [ makeWrapper ];

  npmFlags = "--ignore-scripts";

  postInstall = ''
    # Compile Typescript sources
    ./node_modules/typescript/bin/tsc

    # Create desktop item
    mkdir -p "$out/share/applications"
    cp "${desktopItem}/share/applications/"* "$out/share/applications"

    # Link scalable icon
    mkdir -p "$out/share/icons/hicolor/scalable/apps"
    ln -s "$PWD/media/Icon.svg" "$out/share/icons/hicolor/scalable/apps/caprine.svg"

    # Create electron wrapper
    makeWrapper ${electron}/bin/electron "$out/bin/caprine" \
      --add-flags "$out/lib/node_modules/caprine"
  '';

  meta = with stdenv.lib; {
    homepage = "https://sindresorhus.com/caprine";
    maintainers = with maintainers; [ metadark ];
  };
}
