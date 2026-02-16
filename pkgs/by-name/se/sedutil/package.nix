{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  systemd,
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
  '';

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    systemd
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
