{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:
let
  core = fetchFromGitHub {
    owner = "fvs-lab";
    repo = "core";
    tag = "v0.1.3";
    hash = "sha256-9AjUaTRBrcNr1yYakzXfLBuRCKqDIrVwrEKlQgb4m0o=";
  };
in
buildGoModule (finalAttrs: {
  pname = "fvs2";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "fvs-lab";
    repo = "fvs2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j/jUz/WGOy7qtGDfARtVf1Tv1thk434eRVbq3ePC7RQ=";
  };

  vendorHash = "sha256-gzI8mKGJWRJqUkscOU3wXTscZO+9i6MLKCoyMLkymUY=";

  # Needed for build time tests
  nativeBuildInputs = [ git ];

  preBuild = ''
    cp -r ${core} ../core
  '';

  __structuredAttrs = true;

  meta = {
    description = "Standalone CLI for FVS v2";
    homepage = "https://github.com/fvs-lab/fvs2";
    license = lib.licenses.mit;
    mainProgram = "fvs2";
    maintainers = [ lib.maintainers.Gliczy ];
    platforms = lib.platforms.linux;
  };
})
