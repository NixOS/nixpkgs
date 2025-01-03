{
  lib,
  stdenv,
  fetchFromGitHub,
  asio,
  boost,
  check,
  openssl,
  cmake,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "mariadb-galera";
  version = "26.4.20";

  src = fetchFromGitHub {
    owner = "codership";
    repo = "galera";
    rev = "release_${version}";
    hash = "sha256-R2YQtAuqPkOtcvjS5PPcqAqu153N2+0/WjZt96ZSI1A=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    asio
    boost.dev
    check
    openssl
  ];

  preConfigure = ''
    # make sure bundled asio cannot be used, but leave behind license, because it gets installed
    rm -r asio/{asio,asio.hpp}
  '';

  postInstall = ''
    # for backwards compatibility
    mkdir $out/lib/galera
    ln -s $out/lib/libgalera_smm.so $out/lib/galera/libgalera_smm.so
  '';

  passthru.tests = {
    inherit (nixosTests) mariadb-galera;
  };

  meta = with lib; {
    description = "Galera 3 wsrep provider library";
    mainProgram = "garbd";
    homepage = "https://galeracluster.com/";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ izorkin ] ++ teams.helsinki-systems.members;
    platforms = platforms.all;
    broken = stdenv.isDarwin;
  };
}
