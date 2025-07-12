{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  systemdLibs,
  libnvme,
}:

stdenv.mkDerivation rec {
  pname = "sedutil";
  version = "1.49.13";

  src = fetchFromGitHub {
    owner = "Drive-Trust-Alliance";
    repo = "sedutil";
    tag = version;
    hash = "sha256-bSeTbpeecufXNZKNb5A0gWYF3qkBc2fSmNTZxkDW+Vc=";
  };

  postPatch = ''
    patchShebangs .
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
}
