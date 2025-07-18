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
  version = "2.7.0.48109";

  updateScript = ./update.sh;

  meta = {
    description = "Jetbrains Toolbox";
    homepage = "https://jetbrains.com/";
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
        x86_64-linux = "sha256-ZEtkWKKX4XAd8LujuVVy+lFcgqhhxkEh6F75vl2hRgs=";
        aarch64-linux = "sha256-qAftn6bx8JUtym37PNFsxnyt3twSxWsewKA/XDU/WeY=";
        x86_64-darwin = "sha256-OVg4qDhoHN2eV3grPjM33fzXxw1tI4rA+T/3vDGuLHc=";
        aarch64-darwin = "sha256-/MjoMH06m4aXesKr2VKoiDlhyWlA5MIlYJdqjBcxTnA=";
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
