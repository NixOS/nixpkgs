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

  # fix build with cmake v4
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'cmake_minimum_required(VERSION 2.6.0)' 'cmake_minimum_required(VERSION 3.10)'
  '';

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Turn quickly bulky LAS files into compact LAZ files without information loss";
    homepage = "https://laszip.org";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ michelk ];
    platforms = lib.platforms.unix;
  };
})
