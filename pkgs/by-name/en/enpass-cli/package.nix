{
  lib,
  buildGoModule,
  fetchFromGitHub,
  sqlcipher,
  pkg-config,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "enpass-cli";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "HazCod";
    repo = "enpass-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cVPPBuluUvPnPAlF+OEMYOOTSdPGbJmI1iSRlYqveFQ=";
  };

  vendorHash = "sha256-U9tnzok21yCFPDZprsvqq0NaO07qPS0L+IgVtF2hpvM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    sqlcipher
  ];

  env.CGO_ENABLED = "1";

  postInstall = ''
    mv $out/bin/enpasscli $out/bin/enpass-cli
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line client for Enpass password manager";
    mainProgram = "enpass-cli";
    homepage = "https://github.com/HazCod/enpass-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ deej-io ];
    platforms = lib.platforms.unix;
  };
})
