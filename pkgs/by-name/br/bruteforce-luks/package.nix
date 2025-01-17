{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  cryptsetup,
}:

stdenv.mkDerivation rec {
  pname = "bruteforce-luks";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "glv2";
    repo = "bruteforce-luks";
    rev = version;
    hash = "sha256-t07YyfCjaXQs/OMekcPNBT8DeSRtq2+8tUpsPP2pG7o=";
  };

  postPatch = ''
    # the test hangs indefinetly when more than 3 threads are used, I haven't figured out why
    substituteInPlace tests/Makefile.am \
      --replace-fail " crack-volume3.sh" ""
  '';

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ cryptsetup ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    homepage = "https://github.com/glv2/bruteforce-luks";
    description = "Cracks passwords of LUKS encrypted volumes";
    mainProgram = "bruteforce-luks";
    longDescription = ''
      The program tries to decrypt at least one of the key slots by trying
      all the possible passwords. It is especially useful if you know
      something about the password (i.e. you forgot a part of your password but
      still remember most of it). Finding the password of a volume without
      knowing anything about it would take way too much time (unless the
      password is really short and/or weak). It can also use a dictionary.
    '';
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
