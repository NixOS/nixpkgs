{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libnl,
}:

stdenv.mkDerivation rec {
  pname = "batctl";
  version = "2026.0";

  src = fetchurl {
    url = "https://downloads.open-mesh.org/batman/releases/batman-adv-${version}/${pname}-${version}.tar.gz";
    hash = "sha256-tLcNrmIBBuRe492x9RL2kHVpKxI0PQUhJnQDyyEqSiY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libnl ];

  preBuild = ''
    makeFlags="PREFIX=$out"
  '';

  meta = {
    homepage = "https://www.open-mesh.org/projects/batman-adv/wiki/Wiki";
    description = "B.A.T.M.A.N. routing protocol in a linux kernel module for layer 2, control tool";
    mainProgram = "batctl";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = with lib.platforms; linux;
  };
}
