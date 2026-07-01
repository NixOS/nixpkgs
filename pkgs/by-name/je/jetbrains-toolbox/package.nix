{
  lib,
  stdenvNoCC,
  buildFHSEnv,
  fetchzip,
  fetchurl,
  appimageTools,
  undmg,
}:

let
  pname = "jetbrains-toolbox";
  version = "3.5.0.84344";

  updateScript = ./update.sh;

  meta = {
    description = "JetBrains Toolbox";
    homepage = "https://www.jetbrains.com/toolbox-app";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      ners
      fabiob
    ];
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
    mainProgram = "jetbrains-toolbox";
  };

  selectSystem =
    let
      inherit (stdenvNoCC.hostPlatform) system;
    in
    attrs: attrs.${system} or (throw "Unsupported system: ${system}");

  selectKernel =
    let
      inherit (stdenvNoCC.hostPlatform.parsed) kernel;
    in
    attrs: attrs.${kernel.name} or (throw "Unsupported kernel: ${kernel.name}");

  selectCpu =
    let
      inherit (stdenvNoCC.hostPlatform.parsed) cpu;
    in
    attrs: attrs.${cpu.name} or (throw "Unsupported CPU: ${cpu.name}");

  sourceForVersion =
    version:
    let
      archSuffix = selectCpu {
        x86_64 = "";
        aarch64 = "-arm64";
      };
      hash = selectSystem {
        x86_64-linux = "sha256-u+ATMiioJAmr8wTde4g1hB/DZqPnLZoPNJp6Oiq6m5o=";
        aarch64-linux = "sha256-5sOJ7nrhNDCtAlrh2yoCUX/nGDm6gM5gV/y592zWQqQ=";
        x86_64-darwin = "sha256-o2v30FIeVafjKXWjwEY9Mw+rbNfQyXJZUvDF6+DAR58=";
        aarch64-darwin = "sha256-DDGoHMltZWW/7LtHdDiMwS7HEgs8iPrJqc0XC6YolpY=";
      };
    in
    selectKernel {
      linux = fetchzip {
        url = "https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-${version}${archSuffix}.tar.gz";
        inherit hash;
      };
      darwin = fetchurl {
        url = "https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-${version}${archSuffix}.dmg";
        inherit hash;
      };
    };
in
selectKernel {
  linux =
    let
      src = sourceForVersion version;
    in
    buildFHSEnv {
      inherit pname version meta;
      passthru = {
        inherit src updateScript;
      };
      multiPkgs =
        pkgs:
        with pkgs;
        [
          icu
          libappindicator-gtk3
        ]
        ++ appimageTools.defaultFhsEnvArgs.multiPkgs pkgs;
      runScript = "${src}/bin/jetbrains-toolbox --update-failed";

      extraInstallCommands = ''
        install -Dm0644 ${src}/bin/jetbrains-toolbox.desktop -t $out/share/applications
        install -Dm0644 ${src}/bin/toolbox-tray-color.png $out/share/icons/hicolor/32x32/apps/jetbrains-toolbox.png
      '';
    };

  darwin = stdenvNoCC.mkDerivation (finalAttrs: {
    inherit
      pname
      version
      meta
      ;

    src = sourceForVersion finalAttrs.version;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "JetBrains Toolbox.app";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications $out/bin
      cp -r . $out/Applications/"JetBrains Toolbox.app"
      ln -s $out/Applications/"JetBrains Toolbox.app"/Contents/MacOS/jetbrains-toolbox $out/bin/jetbrains-toolbox

      runHook postInstall
    '';

    passthru = {
      inherit updateScript;
    };
  });
}
