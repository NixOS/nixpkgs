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
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "upa";
    repo = "mscp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zhLU0H2/ZMbrPHD5ULCi5eheAlzS5v/bb1E16hSSc7E=";
    fetchSubmodules = true;
  };

  postPatch = ''
    echo ${lib.escapeShellArg finalAttrs.version} > VERSION
    patch -d libssh -p1 < patch/libssh-0.11.2.patch
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
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ enovamaker ];
  };
})
