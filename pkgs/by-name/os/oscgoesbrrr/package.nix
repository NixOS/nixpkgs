{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  replaceVars,
  iconConvTools,
  nodejs_24,
  pnpmConfigHook,
  pnpm_10,
  electron_40,

  nodejs ? nodejs_24,
  pnpm ? pnpm_10.override { nodejs = nodejs; },
  electron ? electron_40,
}:

let
  sources = import ./sources.nix;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "oscgoesbrrr";
  version = "2.1.13";

  src = fetchFromGitHub {
    owner = "OscToys";
    repo = "OscGoesBrrr";
    tag = "v${finalAttrs.version}";
    inherit (sources.src) hash;
  };

  patches = [
    (replaceVars ./10-hardcode-versions.patch {
      OGB_VERSION = finalAttrs.version;
      NODE_VERSION = nodejs.version;
      PNPM_VERSION = pnpm.version;
    })
  ];

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    makeWrapper
    copyDesktopItems
    iconConvTools
  ];

  buildInputs = [ electron_40 ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    inherit (sources.pnpmDeps) hash;
    fetcherVersion = 3;
  };

  desktopItems = [
    (makeDesktopItem {
      name = "oscgoesbrrr";
      type = "Application";
      desktopName = "OscGoesBrrr";
      genericName = "VRChat OSC Haptics Dashboard";
      exec = "OscGoesBrrr";
      icon = "oscgoesbrrr";
      comment = "Make haptics in real life go BRRR from VRChat";
      categories = [ "Utility" ];
      keywords = [
        "OSC"
        "OGB"
        "VRChat"
      ];
    })
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # install electron bundle
    mkdir -p $out/lib/OscGoesBrrr/app
    cp app/main.bundle.js app/main.bundle.js.map $out/lib/OscGoesBrrr/
    cp app/preload.js app/*.html app/*.png app/*.ico $out/lib/OscGoesBrrr/app/
    echo '{"name":"OscGoesBrrr","version":"${finalAttrs.version}","type": "module","main":"main.bundle.js"}' \
      > $out/lib/OscGoesBrrr/package.json


    # generate icons
    icoFileToHiColorTheme src/icons/ogb-logo.ico oscgoesbrrr $out

    # create electron wrapper application
    mkdir -p $out/bin
    makeWrapper ${electron}/bin/electron $out/bin/OscGoesBrrr \
      --add-flags $out/lib/OscGoesBrrr

    runHook postInstall
  '';

  postFixup = ''
    sed -i "s|Exec=OscGoesBrrr|Exec=$out/bin/OscGoesBrrr|" $out/share/applications/oscgoesbrrr.desktop
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Graphical OSC haptic control dashboard for VRChat";
    longDescription = ''
      OscGoesBrrr provides a bridge for VRChat SPS and TPS plugs and sockets to Intiface Central.
      It also supports OSCQuery to allow other OSC applications to communicate to VRChat.
    '';
    homepage = "https://osc.toys";
    changelog = "https://github.com/OscToys/OscGoesBrrr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.cc-by-nc-sa-40;
    maintainers = with lib.maintainers; [ lactose ];
    mainProgram = "OscGoesBrrr";
  };
})
