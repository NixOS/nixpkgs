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
  version = "1.49.6";

  src = fetchFromGitHub {
    owner = "Drive-Trust-Alliance";
    repo = "sedutil";
    tag = version;
    hash = "sha256-5Fj5bFjtkaxan2vqQTxxlpcR3FK2HrFS6/9cM2xaZRI=";
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
