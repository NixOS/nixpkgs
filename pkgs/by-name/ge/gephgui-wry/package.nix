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
  nodejs_22,
}:
let
  pac-cmd = stdenv.mkDerivation {
    pname = "pac-cmd";
    version = "0-unstable-2020-01-07";

    src = fetchFromGitHub {
      owner = "getlantern";
      repo = "pac-cmd";
      rev = "495bad48b8601385daa8205ec4db504166dff18b";
      hash = "sha256-T4g0FR20sOxJ20H4LTmhrA2EsRe8JYXj6MB2ImkbPsY=";
    };

    postPatch = ''
      rm binaries/*/pac
      substituteInPlace Makefile --replace-fail 'uname -p' 'uname -m'
    '';

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ glib ];
    installPhase = ''
      runHook preInstall

      install -Dm755 -t $out/bin binaries/*/pac

      runHook postInstall
    '';

    meta = {
      description = "Change proxy auto-config settings of operation system";
      homepage = "https://github.com/getlantern/pac-cmd";
      license = lib.licenses.asl20;
      mainProgram = "pac";
      platforms = lib.platforms.all;
    };
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gephgui-wry";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "geph-official";
    repo = "gephgui-pkg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nlWFiEFraI4sUBTs/ZxiHpaeYHert78oPiyFc6LKV30=";
    fetchSubmodules = true;
  };

  gephgui = buildNpmPackage {
    pname = "gephgui";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/gephgui-wry/gephgui";
    npmDepsHash = "sha256-dGzmdvzKp/JHCgDf3NJb0oolgW4Y/spagzpeVpMF28w=";

    # npm dependency install fails with nodejs_24: https://github.com/NixOS/nixpkgs/issues/474535
    nodejs = nodejs_22;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -aR dist/* $out/

      runHook postInstall
    '';
  };

  sourceRoot = "${finalAttrs.src.name}/gephgui-wry";
  cargoHash = "sha256-7EJvcnltKlq94jahnMpvzdFJ8P12HjUGC6AOXirpcg4=";

  nativeBuildInputs = [
    pkg-config
    perl
    copyDesktopItems
    wrapGAppsHook4
  ];

  buildInputs = [ webkitgtk_4_1 ];

  preBuild = ''
    cp -r ${finalAttrs.gephgui}/ gephgui/dist/
  '';

  postInstall = ''
    install -m 444 -D gephgui/public/gephlogo.png $out/share/icons/hicolor/512x512/apps/geph.png
  '';

  preFixup = ''
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

  passthru = {
    inherit pac-cmd;
    inherit (finalAttrs) gephgui;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage=gephgui"
      ];
    };
  };

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
})
