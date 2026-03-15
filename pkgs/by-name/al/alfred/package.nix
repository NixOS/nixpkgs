{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gpsd,
  libcap,
  libnl,
}:

stdenv.mkDerivation rec {
  pname = "alfred";
  version = "2026.0";

  src = fetchurl {
    url = "https://downloads.open-mesh.org/batman/releases/batman-adv-${version}/${pname}-${version}.tar.gz";
    hash = "sha256-35EVL+Mftjd6JM6TEwRFlzUQRpr5N35MycX10l4451E=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gpsd
    libcap
    libnl
  ];

  preBuild = ''
    makeFlags="PREFIX=$out"
  '';

  meta = {
    homepage = "https://www.open-mesh.org/projects/batman-adv/wiki/Wiki";
    description = "B.A.T.M.A.N. routing protocol in a linux kernel module for layer 2, information distribution tool";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = with lib.platforms; linux;
  };
}
