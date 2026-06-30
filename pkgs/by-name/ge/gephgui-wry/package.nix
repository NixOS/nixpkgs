{
  lib,
  rustPlatform,
  webkitgtk_4_1,
  pkg-config,
  openssl,
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
       substituteInPlace Makefile \
        --replace-fail 'uname -p' 'uname -m' \
        --replace-fail 'ifneq ($(filter arm%,$(UNAME_P)),)' 'ifneq ($(filter aarch64 arm%,$(UNAME_P)),)'
    '';

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ glib ];

    preBuild = ''
      mkdir -p binaries/linux_arm
    '';

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
      hasNoMaintainersButDependents = true;
    };
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gephgui-wry";
  version = "5.7.2";

  src = fetchFromGitHub {
    owner = "geph-official";
    repo = "gephgui-pkg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uY2m4TXy4+efRC6WzGjB5Vushgj8zkCp0ctnCJAR+FE=";
    fetchSubmodules = true;
  };

  gephgui = buildNpmPackage {
    pname = "gephgui";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/gephgui-wry/gephgui";
    npmDepsHash = "sha256-GFeHowIv+TiejSNK6kAGAgYcwc2DHu3c4UBEeTScIPk=";

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -aR dist/* $out/

      runHook postInstall
    '';
  };

  sourceRoot = "${finalAttrs.src.name}/gephgui-wry";
  cargoHash = "sha256-Ekl03CvM32E3Q86YZL8eBFYAzDcpAXq8yVi2Fg3t5yc=";

  nativeBuildInputs = [
    pkg-config
    perl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
    wrapGAppsHook4
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ webkitgtk_4_1 ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ openssl ];

  preBuild = ''
    cp -r ${finalAttrs.gephgui}/ gephgui/dist/
  '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      install -m 444 -D gephgui/public/gephlogo.png $out/share/icons/hicolor/512x512/apps/geph.png
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/Applications"
      cp -a ../macos/template.app "$out/Applications/Geph.app"
      chmod -R u+w "$out/Applications/Geph.app"
      install -Dm755 "$out/bin/gephgui-wry" "$out/Applications/Geph.app/Contents/MacOS/bin/gephgui-wry"
      ln -s "$out/Applications/Geph.app/Contents/MacOS/entrypoint" "$out/bin/Geph"
    '';

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      --suffix PATH : ${lib.makeBinPath [ pac-cmd ]}
    )
  '';

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
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
    mainProgram = if stdenv.hostPlatform.isDarwin then "Geph" else "gephgui-wry";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      penalty1083
      MCSeekeri
    ];
  };
})
