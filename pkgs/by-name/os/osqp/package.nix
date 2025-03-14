{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "osqp";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "oxfordcontrol";
    repo = "osqp";
    rev = "v${version}";
    hash = "sha256-enkK5EFyAeLaUnHNYS3oq43HsHY5IuSLgsYP0k/GW8c=";
    fetchSubmodules = true;
  };

  # ref https://github.com/osqp/osqp/pull/481
  # but this patch does not apply directly on v0.6.3
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "$<INSTALL_PREFIX>/\''${CMAKE_INSTALL_INCLUDEDIR}" \
      "\''${CMAKE_INSTALL_FULL_INCLUDEDIR}"
  '';

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Quadratic programming solver using operator splitting";
    homepage = "https://osqp.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ taktoa ];
    platforms = platforms.all;
  };
}
