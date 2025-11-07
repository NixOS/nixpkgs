{
  lib,
  stdenv,

  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  makeDesktopItem,

  cmake,
  copyDesktopItems,
  ninja,

  protobuf,
  qt6Packages,

  sing-geoip,
  sing-geosite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nekoray";
  version = "4.3.7";

  src = fetchFromGitHub {
    owner = "Mahdi-zarei";
    repo = "nekoray";
    tag = finalAttrs.version;
    hash = "sha256-oRoHu9mt4LiGJFe2OEATbPQ8buYT/6o9395BxYg1qKI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    ninja
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    protobuf
    qt6Packages.qtbase
    qt6Packages.qttools
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

    # disable suid request as it cannot be applied to nekobox_core in nix store
    # and prompt users to use NixOS module instead. And use nekobox_core from PATH
    # to make use of security wrappers
    ./nixos-disable-setuid-request.patch
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 nekoray "$out/share/nekoray/nekoray"
    install -Dm644 "$src/res/public/nekobox.png" "$out/share/icons/hicolor/256x256/apps/nekoray.png"

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
      desktopName = "Nekoray";
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

    patches = [
      # also check cap_net_admin so we don't have to set suid
      ./core-also-check-capabilities.patch

      # adds missing entries to the lockfile
      # can be removed next update
      (fetchpatch {
        name = "fix-lockfile.patch";
        url = "https://github.com/Mahdi-zarei/nekoray/commit/6f9b2c69e21b0b86242fcc5731f21561373d0963.patch";
        stripLen = 2;
        hash = "sha256-LDLgCQUXOqaV++6Z4/8r2IaBM+Kz/LckjVsvZn/0lLM=";
      })
    ];

    vendorHash = "sha256-6Q6Qi3QQOmuLBaV4t/CEER6s1MUvL7ER6Hfm44sQk4M=";

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
    maintainers = with lib.maintainers; [
      tomasajt
      aleksana
    ];
    platforms = lib.platforms.linux;
  };
})
