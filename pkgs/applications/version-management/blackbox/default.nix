{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.20181219";
  pname   = "blackbox";

  src = fetchFromGitHub {
    owner  = "stackexchange";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1lpwwwc3rf992vdf3iy1ds07n1xkmad065im2bqzc6kdsbkn7rjx";
  };

  installPhase = ''
    mkdir -p $out/bin && cp -r bin/* $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Safely store secrets in a VCS repo";
    maintainers = with maintainers; [ ericsagnes ];
    license     = licenses.mit;
    platforms   = platforms.all;
  };
}
