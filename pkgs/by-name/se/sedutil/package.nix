{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  systemdLibs,
  libnvme,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sedutil";
  version = "1.49.13";

  src = fetchFromGitHub {
    owner = "Drive-Trust-Alliance";
    repo = "sedutil";
    tag = finalAttrs.version;
    hash = "sha256-bSeTbpeecufXNZKNb5A0gWYF3qkBc2fSmNTZxkDW+Vc=";
  };

  postPatch = ''
    patchShebangs .
    substituteInPlace configure.ac \
      --replace-fail "AM_INIT_AUTOMAKE([-Wall -Werror])" "AM_INIT_AUTOMAKE([-Wall])"
  '';

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    systemdLibs
    libnvme
  ];

  enableParallelBuilding = true;

  meta = {
    description = "DTA sedutil Self encrypting drive software";
    homepage = "https://www.drivetrust.com";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "sedutil-cli";
  };
})
