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
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "upa";
    repo = "mscp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5lX0b3JfjmQh/HlESRMNxqCe2qFRAEZoazysoy252dY=";
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
    teams = [ lib.teams.deshaw ];
    platforms = lib.platforms.unix;
  };
})
