{
  stdenv,
  lib,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  zlib,
  cunit,
  libxcrypt,
}:
stdenv.mkDerivation rec {
  pname = "dcap";
  version = "2.47.14";

  src = fetchFromGitHub {
    owner = "dCache";
    repo = "dcap";
    rev = version;
    sha256 = "sha256-hn4nkFTIbSUUhvf9UfsEqVhphAdNWmATaCrv8jOuC0Y=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];
  buildInputs = [
    zlib
    libxcrypt
  ];

  preConfigure = ''
    patchShebangs bootstrap.sh
    ./bootstrap.sh
  '';

  doCheck = true;

  nativeCheckInputs = [ cunit ];

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
    "doc"
  ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "dCache access protocol client library";
    homepage = "https://github.com/dCache/dcap";
    changelog = "https://github.com/dCache/dcap/blob/master/ChangeLog";
    license = licenses.lgpl2Only;
    platforms = platforms.all;
    mainProgram = "dccp";
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
