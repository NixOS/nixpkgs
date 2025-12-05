{
  lib,
  stdenv,
  fetchFromGitHub,
  asio_1_32_0,
  boost,
  check,
  openssl,
  cmake,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "mariadb-galera";
  version = "26.4.24";

  src = fetchFromGitHub {
    owner = "codership";
    repo = "galera";
    tag = "release_${version}";
    hash = "sha256-mpf+YY0m+UwvemdZt6SfRP9IJlq5IZtlOJMucADc1oM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    # depends on io_service
    asio_1_32_0
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
    maintainers = with maintainers; [ izorkin ];
    teams = [ teams.helsinki-systems ];
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
