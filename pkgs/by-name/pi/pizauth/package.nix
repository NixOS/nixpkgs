{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pizauth";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = "pizauth";
    tag = "pizauth-${finalAttrs.version}";
    hash = "sha256-e9YBeYMC9tfxZoXZi/QBW3FO5V6BAe7RSvVWs7rv0PI=";
  };

  cargoHash = "sha256-9cDVbDCb8vY6KxreyiMX3gp13bXZpxTQOwYbk6TEVpc=";

  preConfigure = ''
    substituteInPlace lib/systemd/user/pizauth.service \
      --replace-fail /usr/bin/ ''${!outputBin}/bin/
  '';

  postInstall = ''
    make PREFIX=$out install ${lib.optionalString stdenv.hostPlatform.isLinux "install-systemd"}
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=pizauth-(.*)" ]; };

  meta = {
    description = "Command-line OAuth2 authentication daemon";
    homepage = "https://github.com/ltratt/pizauth";
    changelog = "https://github.com/ltratt/pizauth/blob/${finalAttrs.src.rev}/CHANGES.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      moraxyc
      doronbehar
    ];
    mainProgram = "pizauth";
  };
})
