{
  lib,
  rustPlatform,
  webkitgtk_4_1,
  pkg-config,
  buildNpmPackage,
  makeDesktopItem,
  fetchFromGitHub,
  nix-update-script,
  perl,
}:
let
  version = "0-unstable-2025-09-04";
  src = fetchFromGitHub {
    owner = "geph-official";
    repo = "gephgui-wry";
    rev = "a85a632448e548f69f9d1eea3d06a4bdc8be3d57";
    hash = "sha256-CmojbfO/8IzeW3Qh6MU4NCUgWarmvqNr38NJzmsyIO4=";
    fetchSubmodules = true;
  };

  pac-real = fetchFromGitHub {
    owner = "geph-official";
    repo = "gephgui-pkg";
    rev = "v5.2.0";
    hash = "sha256-Y122+6E2pWGWYo5OZj4sPhWt5anz/AOhadcPOXY7hAU=";
    sparseCheckout = [ "blobs/linux-x64/pac-real" ];
  };

  gephgui-frontend = buildNpmPackage {
    pname = "gephgui-frontend";
    inherit version src;

    sourceRoot = "${src.name}/gephgui";

    npmDepsHash = "sha256-dGzmdvzKp/JHCgDf3NJb0oolgW4Y/spagzpeVpMF28w=";

    installPhase = ''
      mkdir -p $out
      cp -aR dist/* $out/
    '';

    meta = with lib; {
      description = "Frontend for Geph GUI";
      homepage = "https://github.com/geph-official/gephgui-wry";
      license = licenses.gpl3Only;
      platforms = platforms.all;
    };
  };
in
rustPlatform.buildRustPackage {
  pname = "gephgui-wry";
  inherit version src;

  cargoHash = "sha256-Yjy4vabjD6fYskIq/TmEF279EOarFSzBVRMMUWU9q7Y=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [ webkitgtk_4_1 ];

  runtimeDependencies = [ webkitgtk_4_1 ];

  preBuild = ''
    cp -r ${gephgui-frontend}/ gephgui/dist/
  '';

  # pac-real might not work
  postInstall = ''
    mkdir -p $out/bin
    cp ${pac-real}/blobs/linux-x64/pac-real $out/bin/pac
    chmod +x $out/bin/pac

    install -m 444 -D gephgui/public/gephlogo.png $out/share/icons/hicolor/512x512/apps/geph5.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Geph";
      desktopName = "Geph";
      icon = "geph";
      exec = "gephgui-wry";
      categories = [ "Network" ];
      comment = "Modular Internet censorship circumvention system designed specifically to deal with national filtering";
    })
  ];

  passthru.updateScript = nix-update-script { }; # Not tested.

  meta = with lib; {
    description = "Modular Internet censorship circumvention system designed specifically to deal with national filtering";
    homepage = "https://github.com/geph-official/gephgui-wry";
    mainProgram = "gephgui-wry";
    platforms = lib.platforms.linux; # Theoretically it's cross-platform, but I haven't been able to test it on Windows and macOS devices.
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      penalty1083
      MCSeekeri
    ];
  };
}
