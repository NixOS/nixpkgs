{ stdenv, fetchurl, bash }:

stdenv.mkDerivation rec {
  name = "circleci-${version}";
  version = "0.0.4705-deba4df";

  src = fetchurl {
    url = "https://github.com/circleci/local-cli/archive/v${version}.tar.gz";
    sha256 = "0an0d4n87zv379lbapk4aa5x83nmfwgqf1w5vgvnlkmza49xij2q";
  };

  buildInputs = [ bash ];

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out/bin
    cp circleci.sh $out/bin/circleci
  '';

  meta = with stdenv.lib; {
    homepage = https://circleci.com/docs/2.0/local-cli/;
    description = "Reproduce the CircleCI environment locally and validate config";
    license = licenses.mit;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.unix;
  };
}
