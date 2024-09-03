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
  version = "2.1.1";

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
          hash = "sha256-1e+TeZLSYZjlyHV+KzasysAiWREy6ayuvmllmfZ3f90=";
          stripRoot = false;
        };
        armv7l-linux = fetchzip {
          url = "${base_url}Linux_arm7.zip";
          hash = "sha256-phhfxDgfzHTVA5OexY6aTUNIuW/+3tn0Q2+el3Tu9Os=";
          stripRoot = false;
        };
        aarch64-linux = fetchzip {
          url = "${base_url}Linux_arm64.zip";
          hash = "sha256-VvhbgvxCZBeJVYjjM/n6vr+xzQdolkZngzaU4Te3DbI=";
          stripRoot = false;
        };
        x86_32-linux = fetchzip {
          url = "${base_url}Linux_i386.zip";
          hash = "sha256-pTUNXRqWKPyyKMzJl+pIStVKpepcSX1ZdAxN39q2eZc=";
          stripRoot = false;
        };
        x86_64-linux = fetchzip {
          url = "${base_url}Linux_x86_64.zip";
          hash = "sha256-bs/p15HaWV+XWuERmmih9n2lhI0OZivu97gnFiMCrzQ=";
          stripRoot = false;
        };
        aarch64-darwin = fetchzip {
          url = "${base_url}macOS_arm64.zip";
          hash = "sha256-BD9hefbkXbNzjdeoOqQ4RMgzIXdBt/3z1T0H55sTsP0=";
          stripRoot = false;
        };
        x86_64-darwin = fetchzip {
          url = "${base_url}macOS_x86_64.zip";
          hash = "sha256-6L0eghJwCLZKDh2G/IKv9g1whSWLQbpj+AozumUkm2M=";
          stripRoot = false;
        };
        i686-windows = fetchzip {
          url = "${base_url}Windows_i386.zip";
          hash = "sha256-ZxTOhJbPUjIoDwWIHrEKBBAd3LedJRwoolSZi0h79k8=";
          stripRoot = false;
        };
        x86_64-windows = fetchzip {
          url = "${base_url}Windows_x86_64.zip";
          hash = "sha256-DWBzXQj1+/PKQzvI/R7gkLQz0rLz2h9x+nkPOXOtcyk=";
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
