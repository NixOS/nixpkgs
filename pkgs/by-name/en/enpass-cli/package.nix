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
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "HazCod";
    repo = "enpass-cli";
    tag = "v${version}";
    hash = "sha256-13AhK0qDDANEgicggy1Sdlmo5b0Vlf2sEDzJerhUvG8=";
  };

  vendorHash = "sha256-7K7gdMjJ4cfv6xmuI73U+oW9JlmdN6wGg8vMcD/YThQ=";

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
