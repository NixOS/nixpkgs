{
  lib,
  stdenv,
  rustPlatform,
  nodejs_24,
  src,
  version,
}:

rustPlatform.buildRustPackage {
  pname = "maka-runtime-host-peer";
  inherit src version;

  cargoRoot = "native/runtime-host-peer";
  buildAndTestSubdir = "native/runtime-host-peer";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rtc-0.21.0-rc.1" = "sha256-3zDb+x2IhHBMh8tfumteDE5JG/zZacaevbSCkcqDZk0=";
    };
  };

  doCheck = false;

  installPhase = ''
    runHook preInstall
    install -Dm755 target/${stdenv.hostPlatform.rust.rustcTarget}/release/libmaka_runtime_host_peer${stdenv.hostPlatform.extensions.sharedLibrary} \
      "$out/lib/maka_runtime_host_peer.node"
    runHook postInstall
  '';

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  nativeInstallCheckInputs = [ nodejs_24 ];
  installCheckPhase = ''
    runHook preInstallCheck
    node --eval 'require(process.argv[1])' "$out/lib/maka_runtime_host_peer.node"
    runHook postInstallCheck
  '';

  meta = {
    description = "Native peer transport for Maka";
    homepage = "https://github.com/apache/maka";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sheeeng ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
