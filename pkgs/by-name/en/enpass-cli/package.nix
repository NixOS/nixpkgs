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
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "HazCod";
    repo = "enpass-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SloFiV+tmdjiHjeS/SsDMLZ9gjNB/EOmgexMXpu253I=";
  };

  vendorHash = "sha256-S02hHPA7WSAMLELhfD+2cmsbhxsCiXdPbikU/GGubPc=";

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
