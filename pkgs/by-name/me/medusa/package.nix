{
  lib,
  stdenv,
  fetchFromGitHub,
  freerdp,
  libssh2,
  openssl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "medusa";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "jmk-foofus";
    repo = "medusa";
    tag = finalAttrs.version;
    hash = "sha256-ftn5RBE3NYfjXLq8Gm92sbFW+M925BDuL/VmwfPYXpo=";
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

  meta = {
    description = "Speedy, parallel, and modular, login brute-forcer";
    homepage = "https://github.com/jmk-foofus/medusa";
    changelog = "https://github.com/jmk-foofus/medusa/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "medusa";
  };
})
