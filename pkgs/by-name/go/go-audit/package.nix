{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "go-audit";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "slackhq";
    repo = "go-audit";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-VzxFhaeETmhjYWBLQil10OhV4k8w6EHfV0qnun73gb0=";
  };

  vendorHash = "sha256-g5NP5QY8kNPQLLT9GGqHIQXkaBoZ+Wqna7KknCIwBNM=";

  # Tests need network access
  doCheck = false;

  meta = {
    description = "Alternative to the auditd daemon";
    homepage = "https://github.com/slackhq/go-audit";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
    mainProgram = "go-audit";
  };
})
