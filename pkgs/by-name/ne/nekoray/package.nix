{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  cmake,
  ninja,
  protobuf,
  yaml-cpp,
  zxing-cpp,
  callPackage,
  makeDesktopItem,
  copyDesktopItems,

  v2ray-geoip,
  v2ray-domain-list-community,
  sing-geoip,
  sing-geosite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nekoray";
  version = "3.26";

  # the actual nekoray sources will be under the /nekoray subdirectory
  # the sources of the fetched dependencies will be siblings of it
  src = fetchFromGitHub {
    owner = "MatsuriDayo";
    repo = "nekoray";
    rev = finalAttrs.version;
    hash = "sha256-4zXVjFS4gYdegkR7uPFSvcxjorCBbecL9lkYZXJ5VSo=";
    fetchSubmodules = true;

    postFetch = ''
      mv $out nekoray
      mkdir $out
      mv nekoray $out/nekoray
      cd $out/nekoray

      substituteInPlace libs/get_source.sh --replace-fail \
          './libs/get_source.sh' '. ./libs/get_source.sh'
      . ./libs/get_source.sh

      cd ..

      find -type d -name .git -prune -execdir rm -r {} +

      # upstream has some references to /nix/store inside this file for some reason
      rm sing-box/.goreleaser.yaml
    '';
  };

  sourceRoot = "${finalAttrs.src.name}/nekoray";

  strictDeps = true;

  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    cmake
    ninja
    copyDesktopItems
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qttools
    libsForQt5.qtwayland
    libsForQt5.qtx11extras
    protobuf
    yaml-cpp
    zxing-cpp
  ];

  # NKR_PACKAGE makes sure the app uses the user's config directory to store it's non-static content
  # it's essentially the same as always setting the -appdata flag when running the program
  cmakeFlags = [ (lib.cmakeBool "NKR_PACKAGE" true) ];

  installPhase = ''
    runHook preInstall

    install -Dm755 nekoray "$out/share/nekoray/nekoray"

    # nekoray looks for other files and cores in the same directory it's located at
    ln -s ${finalAttrs.passthru.nekoray-core}/bin/nekoray_core "$out/share/nekoray/nekoray_core"
    ln -s ${finalAttrs.passthru.nekobox-core}/bin/nekobox_core "$out/share/nekoray/nekobox_core"

    install -Dm644 ${v2ray-geoip}/share/v2ray/geoip.dat "$out/share/nekoray/geoip.dat"
    install -Dm644 ${v2ray-domain-list-community}/share/v2ray/geosite.dat "$out/share/nekoray/geosite.dat"
    install -Dm644 ${sing-geoip}/share/sing-box/geoip.db "$out/share/nekoray/geoip.db"
    install -Dm644 ${sing-geosite}/share/sing-box/geosite.db "$out/share/nekoray/geosite.db"

    install -Dm644 "$src/nekoray/res/public/nekoray.png" "$out/share/icons/hicolor/256x256/apps/nekoray.png"

    mkdir -p "$out/bin"
    ln -s "$out/share/nekoray/nekoray" "$out/bin/nekoray"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "nekoray";
      desktopName = "NekoRay";
      exec = "nekoray";
      icon = "nekoray";
      comment = finalAttrs.meta.description;
      terminal = false;
      categories = [ "Network" ];
    })
  ];

  passthru = {
    nekobox-core = callPackage ./nekobox-core.nix { inherit (finalAttrs) version src; };
    nekoray-core = callPackage ./nekoray-core.nix { inherit (finalAttrs) version src; };
  };

  meta = {
    description = "Qt based cross-platform GUI proxy configuration manager";
    homepage = "https://github.com/MatsuriDayo/nekoray";
    license = lib.licenses.gpl3Plus;
    mainProgram = "nekoray";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
