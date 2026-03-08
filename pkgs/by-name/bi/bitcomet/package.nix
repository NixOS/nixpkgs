{
  lib,
  stdenvNoCC,
  buildFHSEnv,
  appimageTools,
  fetchurl,
  desktop-file-utils,
  dpkg,
  runScript ? "bitcometd",
  writeShellScript,
  nix-update,
}:

let
  pname = "bitcomet";
  version = "2.19.2";

  meta = {
    homepage = "https://www.bitcomet.com";
    description = "BitTorrent download client";
    mainProgram = "bitcometd";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = [ ];
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
          x86_64-linux = "sha256-26hpKNCetqV0whfzNo950EAmK+LKC1RsN5f/9HU9zKs=";
          aarch64-linux = "sha256-VrrjQ4dcj0XL2xmNspo2mJ+3BVy9vKyVw6QaHkha0LY=";
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
  inherit pname version meta;

  executableName = "bitcometd";

  runScript = "bitcometd";

  targetPkgs = pkgs: [ bitcomet ] ++ appimageTools.defaultFhsEnvArgs.targetPkgs pkgs;

  multiPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;

  passthru = {
    inherit bitcomet;
    updateScript = writeShellScript "update-bitcomet" ''
      latestVersion=$(curl --fail --silent https://www.cometbbs.com/t/linux%E5%86%85%E6%B5%8B%E7%89%88/88604 | grep -oP 'BitComet-\K[0-9]+\.[0-9]+\.[0-9]+(?=-x86_64\.deb)' | head -n1)
      ${lib.getExe nix-update} pkgsCross.gnu64.bitcomet.bitcomet --version $latestVersion
      ${lib.getExe nix-update} pkgsCross.aarch64-multiplatform.bitcomet.bitcomet --version skip
    '';
  };
}
