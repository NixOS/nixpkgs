{ stdenv, fetchFromGitHub, cmake,
libmicrohttpd,
openssl,
hwloc,
donationLevel
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "xmr-stak-cpu-${version}";
  version = "1.3.0";

  buildInputs = [ cmake libmicrohttpd openssl hwloc ];

  preConfigure = ''sed -i "s|fDevDonationLevel = 2.0|fDevDonationLevel = ${donationLevel}|" donate-level.h'';

  postInstall = ''
      mkdir $out/etc
      mv $out/bin/config.txt $out/etc/xmr-stak-cpu.config.txt
  '';

  src = fetchFromGitHub {
    owner = "fireice-uk";
    repo = "xmr-stak-cpu";
    rev = "v${version}-1.5.0";
    sha256 = "1i12zdzkvmnmx2r40hp71vr019ws7s1gkabwj4my27z6hinw6f8b";
  };

  meta = {
    description = "Universal Stratum pool miner (CPU version)";
    homepage = https://github.com/fireice-uk/xmr-stak-cpu;
    maintainers = [stdenv.lib.maintainers.nico202];
    license = stdenv.lib.licenses.gpl3;
  };
}
