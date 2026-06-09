{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bison,
  flex,
  openldap,
  openssl,
  trousers,
  libcap,
  getent,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opencryptoki";
  version = "3.26.0-unstable-2026-04-09";

  src = fetchFromGitHub {
    owner = "opencryptoki";
    repo = "opencryptoki";
    rev = "ed378f463ef73364c89feb0fc923f4dc867332a3";
    hash = "sha256-1DxlsjPoK3kIQkfguhOlzP2d7dneYRz/Qwp4cH30AhU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    getent
  ];

  buildInputs = [
    openldap
    openssl
    trousers
    libcap
  ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail "/usr/sbin/" "" \
      --replace-fail "/bin/" "" \
      --replace-fail "usermod" "true" \
      --replace-fail "useradd" "true" \
      --replace-fail "groupadd" "true" \
      --replace-fail "chmod" "true" \
      --replace-fail "chown" "true" \
      --replace-fail "chgrp" "true"
  '';

  configureFlags = [
    "--prefix="
    "--disable-ccatok"
    "--disable-icatok"
  ];

  enableParallelBuilding = true;

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  meta = {
    changelog = "https://github.com/opencryptoki/opencryptoki/blob/v${finalAttrs.version}/ChangeLog";
    description = "PKCS#11 implementation for Linux";
    homepage = "https://github.com/opencryptoki/opencryptoki";
    license = lib.licenses.cpl10;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
