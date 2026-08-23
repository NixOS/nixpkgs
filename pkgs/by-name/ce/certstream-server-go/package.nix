{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "certstream-server-go";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "d-Rickyy-b";
    repo = "certstream-server-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jA7zIffCSsn045ORS8OZiCnSBD6x/ZCZSoPEu6R0DWM=";
  };

  vendorHash = "sha256-fFLbEljOxPzkY6LliRIneIMBsMaG0ks7wWZVs/Z9+Ls=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Drop-in replacement in Golang for the certstream server by Calidog";
    homepage = "https://github.com/d-Rickyy-b/certstream-server-go";
    changelog = "https://github.com/d-Rickyy-b/certstream-server-go/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "certstream-server-go";
  };
})
