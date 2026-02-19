{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  apfel,
  applgrid,
  lhapdf,
  root,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apfelgrid";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "nhartland";
    repo = "APFELgrid";
    tag = "v${finalAttrs.version}";
    sha256 = "0l0cyxd00kmb5aggzwsxg83ah0qiwav0shbxkxwrz3dvw78n89jk";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    apfel
    applgrid
    lhapdf
    root
    zlib
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Ultra-fast theory predictions for collider observables";
    mainProgram = "apfelgrid-config";
    license = lib.licenses.mit;
    homepage = "https://nhartland.github.io/APFELgrid/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
