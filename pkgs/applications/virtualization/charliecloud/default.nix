{ stdenv, fetchFromGitHub, python, autoconf, automake, docker, buildah }:

stdenv.mkDerivation rec {

  version = "0.18";
  pname = "charliecloud";

  src = fetchFromGitHub {
    owner = "hpc";
    repo = "charliecloud";
    rev = "v${version}";
    sha256 = "0x2kvp95ld0yii93z9i0k9sknfx7jkgy4rkw9l369fl7f73ghsiq";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ python docker buildah ];

  preConfigure = ''
    patchShebangs test/
    patchShebangs autogen.sh
    ./autogen.sh
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "LIBEXEC_DIR=lib/charliecloud"
  ];

  meta = {
    description = "User-defined software stacks (UDSS) for high-performance computing (HPC) centers";
    longDescription = ''
      Charliecloud uses Linux user namespaces to run containers with no
      privileged operations or daemons and minimal configuration changes on
      center resources. This simple approach avoids most security risks
      while maintaining access to the performance and functionality already
      on offer.
    '';
    homepage = "https://hpc.github.io/charliecloud";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.bzizou ];
    platforms = stdenv.lib.platforms.linux;
  };

}
