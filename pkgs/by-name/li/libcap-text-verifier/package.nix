{
  lib,
  libcap,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "libcap-text-verifier";
  version = "0-unstable";

  src = ./src;

  buildInputs = [ libcap ];

  meta = {
    description = "Verify textual POSIX capability sets";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ amarshall ];
    mainProgram = "libcap-text-verifier";
    platforms = lib.platforms.linux;
  };
}
