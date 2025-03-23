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
  version = "1.49.7";

  src = fetchFromGitHub {
    owner = "Drive-Trust-Alliance";
    repo = "sedutil";
    tag = version;
    hash = "sha256-gas2OMy3p8cQHKsniRXYyxKo98dxmHg44AA2KujLN6w=";
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
