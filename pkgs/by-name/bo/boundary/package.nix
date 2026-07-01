{
  stdenv,
  lib,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "boundary";
  version = "0.21.2";

  src =
    let
      inherit (stdenv.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        x86_64-linux = "linux_amd64";
        aarch64-linux = "linux_arm64";
        x86_64-darwin = "darwin_amd64";
        aarch64-darwin = "darwin_arm64";
      };
      hash = selectSystem {
        x86_64-linux = "sha256-S5wt4Wy2SfO+36YwxQo86vnSIv4I0tMdfXro3i2qS6k=";
        aarch64-linux = "sha256-bu+tYL5uHs67JG1MxCUDIQ9xwYxArbz/FElN0QCXNU4=";
        x86_64-darwin = "sha256-sRPq9+JnKYD5+0JVqhfGpCflHZgFdsrPprJqfxuAlpI=";
        aarch64-darwin = "sha256-PEaxwEKCidLvDbMSfXZ2ehWOwblLjzU+yy9Qq9tavtw=";
      };
    in
    fetchzip {
      url = "https://releases.hashicorp.com/boundary/${version}/boundary_${version}_${suffix}.zip";
      inherit hash;
      stripRoot = false;
    };

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

  passthru.updateScript = ./update.sh;

  meta = {
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
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [
      jk
      techknowlogick
    ];
    platforms = lib.platforms.unix;
    mainProgram = "boundary";
  };
}
