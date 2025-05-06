{
  lib,
  stdenv,

  buildGoModule,
  fetchFromGitHub,
  makeDesktopItem,

  cmake,
  copyDesktopItems,
  ninja,

  libcpr,
  protobuf,
  qt6Packages,
  yaml-cpp,
  zxing-cpp,

  sing-geoip,
  sing-geosite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nekoray";
  version = "4.3.4";

  src = fetchFromGitHub {
    owner = "Mahdi-zarei";
    repo = "nekoray";
    tag = finalAttrs.version;
    hash = "sha256-h0LkH58+QQFeSwqhqOZDcFF0n98YJEHH/1tq72LdZpI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    ninja
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    libcpr
    protobuf
    qt6Packages.qtbase
    qt6Packages.qttools
    yaml-cpp
    zxing-cpp
  ];

  cmakeFlags = [
    # makes sure the app uses the user's config directory to store it's non-static content
    # it's essentially the same as always setting the -appdata flag when running the program
    (lib.cmakeBool "NKR_PACKAGE" true)
  ];

  patches = [
    # if compiled with NKR_PACKAGE, nekoray assumes geoip.db and geosite.db will be found in ~/.config/nekoray
    # we already package those two files in nixpkgs
    # we can't place file at that location using our builder so we must change the search directory to be relative to the built executable
    ./search-for-geodata-in-install-location.patch
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 nekoray "$out/share/nekoray/nekoray"
    mkdir -p "$out/bin"
    ln -s "$out/share/nekoray/nekoray" "$out/bin"

    # nekoray looks for other files and cores in the same directory it's located at
    ln -s ${finalAttrs.passthru.nekobox-core}/bin/nekobox_core "$out/share/nekoray/nekobox_core"

    # our patch also makes nekoray look for geodata files next to the executable
    ln -s ${sing-geoip}/share/sing-box/geoip.db "$out/share/nekoray/geoip.db"
    ln -s ${sing-geosite}/share/sing-box/geosite.db "$out/share/nekoray/geosite.db"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "nekoray";
      desktopName = "nekoray";
      exec = "nekoray";
      icon = "nekoray";
      comment = finalAttrs.meta.description;
      terminal = false;
      categories = [ "Network" ];
    })
  ];

  passthru.nekobox-core = buildGoModule {
    pname = "nekobox-core";
    inherit (finalAttrs) version src;
    sourceRoot = "${finalAttrs.src.name}/core/server";

    vendorHash = "sha256-CTI9wDPJ9dYpUwvszY2nRfi+NW0nO8imt9lsQ7Nd1Q8=";

    # ldflags and tags are taken from script/build_go.sh
    ldflags = [
      "-w"
      "-s"
      "-X github.com/sagernet/sing-box/constant.Version=${finalAttrs.version}"
    ];

    tags = [
      "with_clash_api"
      "with_gvisor"
      "with_quic"
      "with_wireguard"
      "with_utls"
      "with_ech"
      "with_dhcp"
    ];
  };

  # this tricks nix-update into also updating the vendorHash of nekobox-core
  passthru.goModules = finalAttrs.passthru.nekobox-core.goModules;

  meta = {
    description = "Qt based cross-platform GUI proxy configuration manager";
    homepage = "https://github.com/Mahdi-zarei/nekoray";
    license = lib.licenses.gpl3Plus;
    mainProgram = "nekoray";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
