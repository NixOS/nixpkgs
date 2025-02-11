{
  lib,
  stdenv,
  fetchzip,
  coreutils,
  installShellFiles,
  makeWrapper,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gk-cli";
  version = "2.1.2";

  src = (
    finalAttrs.passthru.sources.${stdenv.system}
      or (throw "gk-cli ${finalAttrs.version} unsupported system: ${stdenv.system}")
  );

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -Dm555 gk -t $out/bin/

    installShellCompletion --bash ./**/gk.bash
    installShellCompletion --fish ./**/gk.fish
    installShellCompletion --zsh ./**/_gk

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/gk \
      --prefix PATH : "${lib.makeBinPath [ coreutils ]}"
  '';

  passthru = {
    sources =
      let
        base_url = "https://github.com/gitkraken/gk-cli/releases/download/v${finalAttrs.version}/gk_${finalAttrs.version}_";
      in
      {
        armv6l-linux = fetchzip {
          url = "${base_url}Linux_arm6.zip";
          hash = "sha256-pnEFTkx1JSmQlniVCXvIB6xGD8XyDh9OLDU0V9AZBTs=";
          stripRoot = false;
        };
        armv7l-linux = fetchzip {
          url = "${base_url}Linux_arm7.zip";
          hash = "sha256-qj0++i698s4ELKHU9B2sGIqf9hUJip4+2Car+brkRkM=";
          stripRoot = false;
        };
        aarch64-linux = fetchzip {
          url = "${base_url}Linux_arm64.zip";
          hash = "sha256-vHGhlRHbk2/s3YmBdOPDbalEydpQVFkHiCkBVywa4N0=";
          stripRoot = false;
        };
        x86_32-linux = fetchzip {
          url = "${base_url}Linux_i386.zip";
          hash = "sha256-t+P9SpS9u/17kga74kbYjD6nkjiFusyIwCRGDnkP3tU=";
          stripRoot = false;
        };
        x86_64-linux = fetchzip {
          url = "${base_url}Linux_x86_64.zip";
          hash = "sha256-O6T27edHi20ZFHiNaZKdk/5dtCn2Tpxm0PR934SRwFk=";
          stripRoot = false;
        };
        aarch64-darwin = fetchzip {
          url = "${base_url}macOS_arm64.zip";
          hash = "sha256-LW2K+aveJiyYqfga2jpF3DvvFeHJuozqbc/afgtq2Oc=";
          stripRoot = false;
        };
        x86_64-darwin = fetchzip {
          url = "${base_url}macOS_x86_64.zip";
          hash = "sha256-1w8B4YWouVViTGoUh987pPQIoqdzB0S+M2bBiRI6Kfg=";
          stripRoot = false;
        };
        i686-windows = fetchzip {
          url = "${base_url}Windows_i386.zip";
          hash = "sha256-t81/wK1weZ/uEZ5TzivylARTUqks9rLIG7WzeoWXb1k=";
          stripRoot = false;
        };
        x86_64-windows = fetchzip {
          url = "${base_url}Windows_x86_64.zip";
          hash = "sha256-9yydDMI9Gz/OswRhJHF+2c3Ia0zDmXMbf7byj6PJe24=";
          stripRoot = false;
        };
      };
    updateScript = writeShellScript "update-gk-cli" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      NEW_VERSION=$(curl --silent https://api.github.com/repos/gitkraken/gk-cli/releases/latest | jq '.tag_name | ltrimstr("v")' --raw-output)
      if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi
      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        update-source-version "gk-cli" "$NEW_VERSION" --ignore-same-version --source-key="passthru.sources.$platform"
      done
    '';
  };

  meta = {
    description = "CLI for Git collaboration across multiple repos and services";
    homepage = "https://www.gitkraken.com";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [ lib.maintainers.pinage404 ];
    mainProgram = "gk";
    platforms = builtins.attrNames finalAttrs.passthru.sources;
  };
})
