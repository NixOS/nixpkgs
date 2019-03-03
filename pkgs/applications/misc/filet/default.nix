{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "filet";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "buffet";
    repo = "filet";
    rev = version;
    sha256 = "0f73c4ipc13c7f4xzi3z103kvxpsw9chdfbvk0ahc60clkxy21k3";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A fucking fucking fast file fucker (afffff)";
    homepage = https://github.com/buffet/filet;
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ buffet ];
  };
}
