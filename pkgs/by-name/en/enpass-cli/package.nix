{
  lib,
  buildGoModule,
  fetchFromGitHub,
  sqlcipher,
  pkg-config,
  nix-update-script,
}:

buildGoModule rec {
  pname = "enpass-cli";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "HazCod";
    repo = "enpass-cli";
    tag = "v${version}";
    hash = "sha256-DBpEI3rOoQTnliPES+M4ZtlBk53WkW2bxk05VnpkQ1o=";
  };

  vendorHash = "sha256-tgOo756kNKGvY87ioX81WngeNlRBVdAEL7PXbIdNS3Y=";

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
}
