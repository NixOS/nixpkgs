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
stdenv.mkDerivation (finalAttrs: {
  pname = "dcap";
  version = "2.47.14";

  src = fetchFromGitHub {
    owner = "dCache";
    repo = "dcap";
    rev = finalAttrs.version;
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

  strictDeps = true;

  preConfigure = ''
    patchShebangs --build bootstrap.sh
    ./bootstrap.sh
  '';

  doCheck = true;

  checkInputs = [ cunit ];

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
    "doc"
  ];

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "dCache access protocol client library";
    homepage = "https://github.com/dCache/dcap";
    changelog = "https://github.com/dCache/dcap/blob/master/ChangeLog";
    license = lib.licenses.lgpl2Only;
    platforms = lib.platforms.all;
    mainProgram = "dccp";
    maintainers = with lib.maintainers; [ ShamrockLee ];
  };
})
