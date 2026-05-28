{
  cmake,
  fetchFromGitHub,
  lib,
  lld,
  perl,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sandhole";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "EpicEric";
    repo = "sandhole";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l+9DcqAxrrjLxs/7KxY6QlfIAlwMVjQztt4lgJJMsyI=";
  };

  cargoHash = "sha256-euWvpEjSW2JeDysBul5eR4M27LwkRSZDlsp57lMBpAE=";

  nativeBuildInputs = [
    cmake
    perl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ lld ];
  strictDeps = true;

  useNextest = true;
  # Skip tests that require networking.
  cargoTestFlags = [ "--profile=no-network" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Expose HTTP/SSH/TCP services through SSH port forwarding";
    longDescription = ''
      A reverse proxy that just works with an OpenSSH client.
      No extra software required to beat NAT!
    '';
    homepage = "https://sandhole.com.br";
    changelog = "https://github.com/EpicEric/sandhole/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "sandhole";
    maintainers = with lib.maintainers; [ EpicEric ];
    platforms = lib.platforms.all;
  };
})
