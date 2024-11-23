{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.2.0";
  pname = "laszip";

  src = fetchFromGitHub {
    owner = "LASzip";
    repo = "LASzip";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TXzse4oLjNX5R2xDR721iV+gW/rP5z3Zciv4OgxfeqA=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Turn quickly bulky LAS files into compact LAZ files without information loss";
    homepage = "https://laszip.org";
    license = licenses.lgpl2;
    maintainers = [ maintainers.michelk ];
    platforms = platforms.unix;
  };
})
