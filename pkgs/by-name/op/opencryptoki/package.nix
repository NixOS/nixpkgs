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
  version = "3.25.0";

  src = fetchFromGitHub {
    owner = "opencryptoki";
    repo = "opencryptoki";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JIDy5LY2rJqMM1uWDWn6Q62kJ+7pYU4G7zptkbyvf9Q=";
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
