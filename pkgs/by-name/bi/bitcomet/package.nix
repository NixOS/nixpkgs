{
  lib,
  stdenvNoCC,
  buildFHSEnv,
  appimageTools,
  fetchurl,
  desktop-file-utils,
  dpkg,
  webkitgtk_4_0,
  runScript ? "BitComet",
}:

let
  pname = "bitcomet";
  version = "2.15.0";

  meta = {
    homepage = "https://www.bitcomet.com";
    description = "BitTorrent download client";
    mainProgram = "BitComet";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ ];
  };

  bitcomet = stdenvNoCC.mkDerivation {
    inherit pname version meta;

    src =
      let
        selectSystem =
          attrs:
          attrs.${stdenvNoCC.hostPlatform.system}
            or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
        arch = selectSystem {
          x86_64-linux = "x86_64";
          aarch64-linux = "arm64";
        };
      in
      fetchurl {
        url = "https://download.bitcomet.com/linux/${arch}/BitComet-${version}-${arch}.deb";
        hash = selectSystem {
          x86_64-linux = "sha256-YmcHcrqw4Ue8uyQqYcLWTYS5WYQro3kk7VLY8pfIsRQ=";
          aarch64-linux = "sha256-Bfg20aKU90Ap8scn4eHtf451uxPfWcnQCrh5gWRQmsU=";
        };
      };

    nativeBuildInputs = [
      dpkg
      desktop-file-utils
    ];

    installPhase = ''
      runHook preInstall

      desktop-file-edit usr/share/applications/bitcomet.desktop \
        --remove-key="Version" \
        --remove-key="Comment" \
        --set-key="Exec" --set-value="BitComet" \
        --set-icon="bitcomet"
      cp -r usr $out

      runHook postInstall
    '';
  };
in
buildFHSEnv {
  inherit
    pname
    version
    runScript
    meta
    ;

  executableName = "BitComet";

  targetPkgs =
    pkgs:
    [
      bitcomet
      webkitgtk_4_0
    ]
    ++ appimageTools.defaultFhsEnvArgs.targetPkgs pkgs;

  multiPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -s ${bitcomet}/share/applications $out/share/applications
    ln -s ${bitcomet}/share/icons $out/share/icons
  '';
}
