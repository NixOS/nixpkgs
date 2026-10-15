{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "rowhammer-test";
  version = "0-unstable-2015-08-11";

  src = fetchFromGitHub {
    owner = "google";
    repo = "rowhammer-test";
    rev = "c1d2bd9f629281402c10bb10e52bc1f1faf59cc4";
    hash = "sha256-kYQE8MRFCh55NfV/ih21uyz6n2Yz7sYPgTrKV6plbrk=";
  };

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isi686 "-Wno-error=format";

  buildPhase = "sh -e make.sh";

  installPhase = ''
    mkdir -p $out/bin
    cp rowhammer_test double_sided_rowhammer $out/bin
  '';

  meta = {
    description = "Test DRAM for bit flips caused by the rowhammer problem";
    homepage = "https://github.com/google/rowhammer-test";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
