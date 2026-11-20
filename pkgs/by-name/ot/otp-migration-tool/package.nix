{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "otp-migration-tool";
  version = "0.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mshegolev";
    repo = "otp-migration-tool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J79wCmmI8oV4svQ2zH9Bho0jCTniAfCKw7cr5Td/Vsk=";
  };

  vendorHash = "sha256-we6goW4PVTN0jdlsK942I9Q1aP1gft9DX72G4Tdkgs8=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Decode Google Authenticator migration QR codes (otpauth-migration://) into otpauth:// URIs, base32 secrets, and TOTP codes. Pure-Go, single static binary, no system deps";
    homepage = "https://github.com/mshegolev/otp-migration-tool";
    changelog = "https://github.com/mshegolev/otp-migration-tool/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "otp-migrate";
  };
})
