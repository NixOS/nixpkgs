{
  lib,
  stdenv,
  fetchFromGitHub,
  freerdp,
  libssh2,
  openssl,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "medusa";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "jmk-foofus";
    repo = "medusa";
    tag = version;
    hash = "sha256-devirQMmS8mtxT5H5XafRRvCyfcvwoWxtTp0V1SJeSM=";
  };

  outputs = [
    "out"
    "man"
  ];

  configureFlags = [ "--enable-module-ssh=yes" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    freerdp
    openssl
    libssh2
  ];

  meta = with lib; {
    description = "Speedy, parallel, and modular, login brute-forcer";
    homepage = "https://github.com/jmk-foofus/medusa";
    changelog = "https://github.com/jmk-foofus/medusa/releases/tag/${src.tag}";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "medusa";
  };
}
