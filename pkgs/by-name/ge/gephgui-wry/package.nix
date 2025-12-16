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
  stdenv,
  glib,
  copyDesktopItems,
  wrapGAppsHook4,
}:
let
  version = "5.4.0";
  src = fetchFromGitHub {
    owner = "geph-official";
    repo = "gephgui-pkg";
    rev = "v${version}";
    hash = "sha256-KeQk2IB3DaMR8nHLliT78sDpbRySIlp8GsjnGTOFCbQ=";
    fetchSubmodules = true;
  };

  gephgui = buildNpmPackage {
    pname = "gephgui";
    inherit version src;

    sourceRoot = "${src.name}/gephgui-wry/gephgui";

    npmDepsHash = "sha256-dGzmdvzKp/JHCgDf3NJb0oolgW4Y/spagzpeVpMF28w=";

    installPhase = ''
      mkdir -p $out
      cp -aR dist/* $out/
    '';
  };

  pac-cmd = stdenv.mkDerivation {
    pname = "pac-cmd";
    version = "0-unstable-2020-01-07";

    src = fetchFromGitHub {
      owner = "getlantern";
      repo = "pac-cmd";
      rev = "495bad48b8601385daa8205ec4db504166dff18b";
      hash = "sha256-T4g0FR20sOxJ20H4LTmhrA2EsRe8JYXj6MB2ImkbPsY=";
    };

    postPatch = "
      rm binaries/*/pac
      substituteInPlace Makefile --replace-fail 'uname -p' 'uname -m'
    ";

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ glib ];
    installPhase = ''
      runHook preInstall

      install -Dm755 -t $out/bin binaries/*/pac

      runHook postInstall
    '';

    meta = {
      description = "Simple Go library to toggle on and off system pac for various OS";
      homepage = "https://github.com/getlantern/pac";
      license = lib.licenses.unfree;
      mainProgram = "pac";
      platforms = lib.platforms.all;
    };
  };
in
rustPlatform.buildRustPackage {
  pname = "gephgui-wry";
  inherit version src;
  sourceRoot = "${src.name}/gephgui-wry";

  cargoHash = "sha256-7EJvcnltKlq94jahnMpvzdFJ8P12HjUGC6AOXirpcg4=";

  nativeBuildInputs = [
    pkg-config
    perl
    copyDesktopItems
    wrapGAppsHook4
  ];

  buildInputs = [ webkitgtk_4_1 ];

  preBuild = ''
    cp -r ${gephgui}/ gephgui/dist/
  '';

  postInstall = ''
    install -m 444 -D gephgui/public/gephlogo.png $out/share/icons/hicolor/512x512/apps/geph.png

    gappsWrapperArgs+=(
      --suffix PATH : ${lib.makeBinPath [ pac-cmd ]}
    )
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Geph";
      desktopName = "Geph";
      icon = "geph";
      exec = "gephgui-wry";
      categories = [ "Network" ];
      comment = "Modular Internet censorship circumvention system designed specifically to deal with national filtering";
      startupWMClass = "geph";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modular Internet censorship circumvention system designed specifically to deal with national filtering";
    homepage = "https://github.com/geph-official/gephgui-wry";
    mainProgram = "gephgui-wry";
    platforms = lib.platforms.linux;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      penalty1083
      MCSeekeri
    ];
  };
}
