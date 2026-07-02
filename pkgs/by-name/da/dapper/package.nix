{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dapper";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = "dapper";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-V+lHnOmIWjI1qmoJ7+pp+cGmJAtSeY+r2I9zykswQzM=";
  };
  vendorHash = null;

  patchPhase = ''
    substituteInPlace main.go --replace 0.0.0 ${finalAttrs.version}
  '';

  meta = {
    description = "Docker build wrapper";
    mainProgram = "dapper";
    homepage = "https://github.com/rancher/dapper";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ kuznero ];
  };
})
