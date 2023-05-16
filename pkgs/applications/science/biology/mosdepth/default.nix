<<<<<<< HEAD
{ lib, nimPackages, fetchFromGitHub, docopt, hts, pcre }:

nimPackages.buildNimPackage rec {
  pname = "mosdepth";
  version = "0.3.4";
=======
{lib, nimPackages, fetchFromGitHub, pcre}:

nimPackages.buildNimPackage rec {
  pname = "mosdepth";
  version = "0.3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "mosdepth";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-7uteYTCbAaXedPqk0WtHpqTfUWH/+rRW8aSlFixkEko=";
  };

  buildInputs = [ docopt hts pcre ];
  nimFlags = hts.nimFlags ++ [ "--threads:off" ];
=======
    sha256 = "sha256-de3h3SXnXlqjuLT1L66jj/1AoiTuFc3PVJYjm7s8Fj8=";
  };

  buildInputs = with nimPackages; [ docopt hts-nim pcre ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "fast BAM/CRAM depth calculation for WGS, exome, or targeted sequencing";
    license = licenses.mit;
    homepage = "https://github.com/brentp/mosdepth";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.linux;
  };
}
