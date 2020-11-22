{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2.0.0";
  pname   = "blackbox";

  src = fetchFromGitHub {
    owner  = "stackexchange";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1plwdmzds6dq2rlp84dgiashrfg0kg4yijhnxaapz2q4d1vvx8lq";
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
