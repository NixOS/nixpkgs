{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "authz0";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = "authz0";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NrArxuhzd57NIdM4d9p/wfCB1e6l83pV+cjjCgZ9YtM=";
  };

  vendorHash = "sha256-ARPrArvCgxLdCaiUdJyjB/9GbbldnMXwFbyYubbsqxc=";

  meta = {
    description = "Automated authorization test tool";
    mainProgram = "authz0";
    homepage = "https://github.com/hahwul/authz0";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
