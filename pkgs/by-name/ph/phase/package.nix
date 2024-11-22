{
  lib,
  stdenv,
  fetchurl,
  unzip,
  installShellFiles,
  makeWrapper,
  autoPatchelfHook,
  zlib,
  glibc,
}:

let
  pname = "phase";
  version = "1.18.6"; # This will be auto-updated by update.sh
  hashes = lib.importJSON ./hashes.json;

  # Binary target map
  systemInfo = {
    "x86_64-linux" = {
      archivePath = "Linux-binary";
      archString = "linux_amd64";
    };
    "aarch64-linux" = {
      archivePath = "Linux-binary-arm64";
      archString = "linux_arm64";
    };
    "x86_64-darwin" = {
      archivePath = "Darwin-binary";
      archString = "macos_amd64";
    };
    "aarch64-darwin" = {
      archivePath = "Darwin-binary-arm64";
      archString = "macos_arm64";
    };
  };

  inherit (stdenv.hostPlatform) system;
  info = systemInfo.${system};

  runtimeDeps = [
    stdenv.cc.cc.lib
    zlib
    glibc
  ];
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/phasehq/cli/releases/download/v${version}/phase_cli_${info.archString}_${version}.zip";
    hash = hashes.${system};
  };

  nativeBuildInputs = [
    unzip
    installShellFiles
    makeWrapper
    autoPatchelfHook # This will automatically fix library references
  ];

  buildInputs = runtimeDeps;

  installPhase = ''
    runHook preInstall

    # Create a directory to hold both the binary and _internal
    mkdir -p $out/{bin,libexec/phase}

    # Install both the binary and _internal directory to libexec
    install -Dm755 "phase/phase" "$out/libexec/phase/phase"
    if [ -d "phase/_internal" ]; then
      cp -r "phase/_internal" "$out/libexec/phase/"
    fi

    # Create a wrapper script that ensures the binary can find _internal
    makeWrapper $out/libexec/phase/phase $out/bin/phase \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeDeps} \
      --set PYTHONPATH $out/libexec/phase \
      --set PYTHONHOME $out/libexec/phase

    runHook postInstall
  '';

  # Prevent stripping of binaries as it might break PyInstaller's binary
  dontStrip = true;

  meta = {
    description = "Secure management system for application secrets and environment variables";
    longDescription = ''
      Open source secret management platform enabling development teams to store,
      organize and deploy application secrets across different environments with
      end-to-end encryption, version control integration and fine-grained access controls'';
    homepage = "https://phase.dev";
    changelog = "https://github.com/phasehq/cli/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nimish ];
    mainProgram = "phase";
    platforms = builtins.attrNames systemInfo;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
