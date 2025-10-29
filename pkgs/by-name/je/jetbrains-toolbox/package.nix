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
  version = "2.9.1.58121";

  updateScript = ./update.sh;

  meta = {
    description = "JetBrains Toolbox";
    homepage = "https://www.jetbrains.com/toolbox-app";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ ners ];
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
        x86_64-linux = "sha256-RrE5NACYPS+ekZYFl/6MOTHOmn0u4zn7pi1q/prmr+s=";
        aarch64-linux = "sha256-z5Bm761XjmkX1vq0ygx3bQpsdK7HN5KcJl6mojt9hXg=";
        x86_64-darwin = "sha256-GbdLpUSn0nlGIwsuKq5AIaizbd4fIpM8QKsQEbhFwXc=";
        aarch64-darwin = "sha256-tSqUvIfNt8iyLof8UU0A40mI9EpFABxDE+1B1adSQ/o=";
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
        install -Dm0644 ${src}/bin/toolbox-tray-color.png $out/share/pixmaps/jetbrains-toolbox.png
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
