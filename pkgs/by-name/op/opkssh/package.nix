{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "opkssh";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "openpubkey";
    repo = "opkssh";
    tag = "v${version}";
    hash = "sha256-RtTo/wj4v+jtJ4xZJD0YunKtxT7zZ1esgJOSEtxnLOg=";
  };

  vendorHash = "sha256-MK7lEBKMVZv4jbYY2Vf0zYjw7YV+13tB0HkO3tCqzEI=";

  ldflags = [ "-X main.Version=${version}" ];

  meta = {
    description = "Enables SSH to be used with OpenID Connect";
    homepage = "https://github.com/openpubkey/opkssh";
    changelog = "https://github.com/openpubkey/opkssh/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sarcasticadmin ];
    mainProgram = "opkssh";
  };
}
