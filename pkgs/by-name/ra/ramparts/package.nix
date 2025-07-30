{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ramparts";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "getjavelin";
    repo = "ramparts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+MVVO9KV0Iej+jBdYpSMLHBwGYpvOqyKOuG78GIwaX0=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "mcp (model context protocol) scanner";
    longDescription = ''
      Mcp scan that scans any mcp server for indirect attack vectors
      and security or configuration vulnerabilities.
    '';
    homepage = "https://github.com/getjavelin/ramparts";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "ramparts";
  };
})
