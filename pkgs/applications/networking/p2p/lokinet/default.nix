{ stdenv
, lib
, fetchFromGitHub
, cmake
, libevent
, libsodium
, libuv
, nlohmann_json
, pkg-config
, sqlite
, systemd
, unbound
, zeromq
}:

stdenv.mkDerivation rec {
  pname = "lokinet";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "oxen-io";
    repo = "lokinet";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-AaGsRg9S9Cng9emI/mN09QSOIRbE+x3916clWAwLnRs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libevent
    libuv
    libsodium
    nlohmann_json
    sqlite
    systemd
    unbound
    zeromq
  ];

  cmakeFlags = [
    "-DGIT_VERSION=v${version}"
    "-DWITH_BOOTSTRAP=OFF" # we provide bootstrap files manually
    "-DWITH_SETCAP=OFF"
  ];

  # copy bootstrap files
  # see https://github.com/oxen-io/lokinet/issues/1765#issuecomment-938208774
  postInstall = ''
    mkdir -p $out/share/testnet
    cp $src/contrib/bootstrap/mainnet.signed $out/share/bootstrap.signed
    cp $src/contrib/bootstrap/testnet.signed $out/share/testnet/bootstrap.signed
  '';

  meta = with lib; {
    description = "Anonymous, decentralized and IP based overlay network for the internet";
    homepage = "https://lokinet.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wyndon ];
  };
}
