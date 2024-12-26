{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "charls";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "team-charls";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-c1wrk6JLcAH7TFPwjARlggaKXrAsLWyUQF/3WHlqoqg=";
  };

  postPatch = ''
    substituteInPlace src/charls-template.pc  \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@  \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  # note this only runs some basic tests, not the full test suite,
  # but the recommended `charlstest -unittest` fails with an inscrutable C++ IO error
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/team-charls/charls";
    description = "JPEG-LS library implementation in C++";
    maintainers = with maintainers; [ bcdarwin ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
