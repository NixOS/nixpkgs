{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "slit";
  version = "1.3.0-unstable-2022-08-06";

  src = fetchFromGitHub {
    owner = "tigrawap";
    repo = "slit";
    rev = "d18e9c338415880d7fd6cfd20505aa461466f81e";
    hash = "sha256-BP91sMtOD/ntX8SoZAxTlU+6Ek25PHCfBaf/jcR/iy4=";
  };

  vendorHash = "sha256-Ryx+O0wj95SkouYZbRErvw5wanw3cJo2kiXmk9l3YFg=";

  meta = {
    description = "Modern $PAGER for noisy logs";
    homepage = "https://github.com/tigrawap/slit";
    license = lib.licenses.mit;
    mainProgram = "slit";
    maintainers = with lib.maintainers; [
      robsach
    ];
  };

  __structuredAttrs = true;
  strictDeps = true;
})
