{
  lib,
  libcap,
  nixosTests,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "libcap-text-verifier";
  version = "0-unstable";

  __structuredAttrs = true;
  strictDeps = true;

  src = ./src;

  buildInputs = [ libcap ];

  doCheck = true;

  passthru = {
    tests = {
      vm = nixosTests.wrappers;
    };
  };

  meta = {
    description = "Verify textual POSIX capability sets";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ amarshall ];
    mainProgram = "libcap-text-verifier";
    platforms = lib.platforms.linux;
  };
}
