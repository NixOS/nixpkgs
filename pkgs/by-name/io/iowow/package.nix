{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "iowow";
  version = "1.4.16";

  src = fetchFromGitHub {
    owner = "Softmotions";
    repo = "iowow";
    rev = "v${version}";
    hash = "sha256-4TL/ZNVtRc4+xk1qj0pnUMIA2kyMsBcBqpMeEvvbGUg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  postPatch = ''
    substituteInPlace src/tmpl/libiowow.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_BINDIR@ @CMAKE_INSTALL_FULL_BINDIR@
  '';

  meta = with lib; {
    description = "A C utility library and persistent key/value storage engine";
    homepage = "https://github.com/Softmotions/iowow";
    changelog = "https://github.com/Softmotions/iowow/blob/${src.rev}/Changelog";
    license = licenses.mit;
    maintainers = with maintainers; [ rs0vere ];
    platforms = platforms.all;
  };
}
