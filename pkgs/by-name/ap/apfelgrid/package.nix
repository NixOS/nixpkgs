{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  apfel,
  applgrid,
  lhapdf,
  root5,
}:

stdenv.mkDerivation rec {
  pname = "apfelgrid";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "nhartland";
    repo = "APFELgrid";
    rev = "v${version}";
    sha256 = "0l0cyxd00kmb5aggzwsxg83ah0qiwav0shbxkxwrz3dvw78n89jk";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    apfel
    applgrid
    lhapdf
    root5
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Ultra-fast theory predictions for collider observables";
    mainProgram = "apfelgrid-config";
    license = licenses.mit;
    homepage = "https://nhartland.github.io/APFELgrid/";
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
