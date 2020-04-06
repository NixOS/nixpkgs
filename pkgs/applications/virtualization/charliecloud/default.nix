{ stdenv, fetchFromGitHub, python }:

stdenv.mkDerivation rec {

  version = "0.12";
  pname = "charliecloud";

  src = fetchFromGitHub {
    owner = "hpc";
    repo = "charliecloud";
    rev = "v${version}";
    sha256 = "177rcf1klcxsp6x9cw75cmz3y2izgd1hvi1rb9vc6iz9qx1nmk3v";
  };

  buildInputs = [ python ];

  preConfigure = ''
    substituteInPlace Makefile --replace '/bin/bash' '${stdenv.shell}'
    patchShebangs test/
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "LIBEXEC_DIR=lib/charliecloud"
  ];

  postInstall = ''
    mkdir -p $out/share/charliecloud
    mv $out/lib/charliecloud/examples $out/share/charliecloud
    mv $out/lib/charliecloud/test $out/share/charliecloud
  '';

  meta = {
    description = "User-defined software stacks (UDSS) for high-performance computing (HPC) centers";
    longDescription = ''
      Charliecloud uses Linux user namespaces to run containers with no
      privileged operations or daemons and minimal configuration changes on
      center resources. This simple approach avoids most security risks
      while maintaining access to the performance and functionality already
      on offer.
    '';
    homepage = https://hpc.github.io/charliecloud;
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.bzizou ];
    platforms = stdenv.lib.platforms.linux;
  };

}
