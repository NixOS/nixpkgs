{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dbmate";
  version = "2.27.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    tag = "v${version}";
    hash = "sha256-HlX84eqM9s9EWCKnFDqcpUoEBc20/fpw1KHQ7q0UkLo=";
  };

  vendorHash = "sha256-yZmTzoa/tl/vJWX5Ds0wL14iAc2uxJHRWCS5XMN12Hs=";

  doCheck = false;

  meta = {
    description = "Database migration tool";
    mainProgram = "dbmate";
    homepage = "https://github.com/amacneil/dbmate";
    changelog = "https://github.com/amacneil/dbmate/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ manveru ];
  };
}
