{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  openssl,
  krb5,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mscp";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "upa";
    repo = "mscp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TWwvPLqGLhh/IE+hIz/jwaGLBoASs78Iqai1TxN7Wps=";
    fetchSubmodules = true;
  };

  postPatch = ''
    echo ${lib.escapeShellArg finalAttrs.version} > VERSION
    patch -d libssh -p1 < patch/libssh-0.10.6-2-g6f1b1e76.patch
  '';

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    krb5
    openssl
    zlib
  ];

  meta = {
    description = "Transfer files over multiple SSH (SFTP) connections";
    homepage = "https://github.com/upa/mscp";
    mainProgram = "mscp";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.deshaw.members;
    platforms = lib.platforms.unix;
  };
})
