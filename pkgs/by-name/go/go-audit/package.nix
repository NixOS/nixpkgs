{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "go-audit";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "slackhq";
    repo = "go-audit";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Si8OuvQOyRN17DJC3mvFS7xkpbID8zcAD8n44VSLsTA=";
  };

  vendorHash = "sha256-eUuLLpF8p7nTiddRy0hlqZ+n+OyvyJ1D20X1jvqKVC8=";

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
