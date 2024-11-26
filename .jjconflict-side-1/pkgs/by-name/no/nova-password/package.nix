{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "nova-password";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "sapcc";
    repo = "nova-password";
    rev = "refs/tags/v${version}";
    hash = "sha256-tjjP+LmYaqpzmTk3tgFqZlG1KEeAkfI7RxzSm97jWVU=";
  };

  vendorHash = "sha256-MwemuOaXGl0eF+lVtMCgbBeJGILmaeEHcbu+xp8Lm70=";

  meta = {
    description = "Decrypt the admin password generated for the VM in OpenStack";
    homepage = "https://github.com/sapcc/nova-password";
    license = lib.licenses.asl20;
    mainProgram = "nova-password";
    maintainers = with lib.maintainers; [ vinetos ];
    platforms = lib.platforms.all;
  };
}
