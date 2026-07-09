{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  core = fetchFromGitHub {
    owner = "fvs-lab";
    repo = "core";
    tag = "v0.0.1";
    hash = "sha256-IBNNa5LGjtPNWhI0PC0NX8rK8z2LnfzOpKpDE1TZQhw=";
  };
in
buildGoModule (finalAttrs: {
  pname = "fvs2";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "fvs-lab";
    repo = "fvs2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ngKyuDYj/HO//uNA/U5VNemoF4XcpEMS6uHsGmli7DU=";
  };

  vendorHash = "sha256-+B0wYZnaPbtQUVvcOsth2IIXsj4SgZ0NPqL/GabphzA=";

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
