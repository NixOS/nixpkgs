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
  version = "26.4.22";

  src = fetchFromGitHub {
    owner = "codership";
    repo = "galera";
    rev = "release_${version}";
    hash = "sha256-Vi5gLl53ytgmAGYN/dHLDAaUqNb8mHmeqB/I6Sdbn1I=";
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
    broken = stdenv.hostPlatform.isDarwin;
  };
}
