{
  stdenv,
  lib,
  fetchzip,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
}:
let
  url' =
    version: suffix:
    "https://releases.hashicorp.com/boundary/${version}/boundary_${version}_${suffix}.zip";
in
stdenv.mkDerivation rec {
  pname = "boundary";
  version = "0.17.0";

  src =
    passthru.sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D boundary $out/bin/boundary
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/boundary --help
    $out/bin/boundary version
    runHook postInstallCheck
  '';

  dontPatchELF = true;
  dontPatchShebangs = true;
  dontStrip = true;

  passthru = {
    sources = {
      "aarch64-darwin" = fetchzip {
        url = url' version "darwin_arm64";
        hash = "sha256-QbmSwwE345OfR2RvEyTzr4P5jjlDi1qANbnbRuFyNdo=";
        stripRoot = false;
      };
      "aarch64-linux" = fetchzip {
        url = url' version "linux_arm64";
        hash = "sha256-6G0BKIk+AN/B97vAdrwAy9c0dONtCJk30MUlfdLL9a0=";
        stripRoot = false;
      };
      "x86_64-darwin" = fetchzip {
        url = url' version "darwin_amd64";
        hash = "sha256-OKKbG6VH4xUSK3GsrXpKY2/PI2DWuveXges0XwGIecA=";
        stripRoot = false;
      };
      "x86_64-linux" = fetchzip {
        url = url' version "linux_amd64";
        hash = "sha256-1yDIyAaYbWrtgHvuta8KrYam/Q/rfNYNqgl7EXfQ+5E=";
        stripRoot = false;
      };
    };
    updateScript = writeShellScript "update-boundary" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      BOUNDARY_VER=$(curl --silent https://api.github.com/repos/hashicorp/boundary/releases/latest | jq '.tag_name | ltrimstr("v")' --raw-output)
      if [[ "${version}" = "$BOUNDARY_VER" ]]; then
          echo "The new version same as the old version."
          # exit 0
      fi
      for platform in ${lib.escapeShellArgs meta.platforms}; do
        update-source-version "boundary" "$BOUNDARY_VER" --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };

  meta = with lib; {
    homepage = "https://boundaryproject.io/";
    changelog = "https://github.com/hashicorp/boundary/blob/v${version}/CHANGELOG.md";
    description = "Enables identity-based access management for dynamic infrastructure";
    longDescription = ''
      Boundary provides a secure way to access hosts and critical systems
      without having to manage credentials or expose your network, and is
      entirely open source.

      Boundary is designed to be straightforward to understand, highly scalable,
      and resilient. It can run in clouds, on-prem, secure enclaves and more,
      and does not require an agent to be installed on every end host.
    '';
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.bsl11;
    maintainers = with maintainers; [
      jk
      techknowlogick
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "boundary";
  };
}
