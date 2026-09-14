{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "putioarr";
  version = "0.6.13";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "wouterdebie";
    repo = "putioarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SPS433HxE6FhF8fN1c6tDQ63QNPiy9a2vSzpD1130u4=";
  };

  cargoHash = "sha256-BzbqLBLf5uGhahC15MTCH3nEnbM5fDn3nY3dDoo2Gb4=";

  meta = {
    description = "put.io to sonarr/radarr/whisparr proxy";
    homepage = "https://github.com/wouterdebie/putioarr";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.squat ];
    mainProgram = "putioarr";
  };
})
