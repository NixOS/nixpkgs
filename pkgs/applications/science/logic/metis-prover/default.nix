{ stdenv, fetchFromGitHub, perl, mlton }:

stdenv.mkDerivation rec {
  name = "metis-prover-${version}";
  version = "2.3.20160713";

  src = fetchFromGitHub {
    owner = "gilith";
    repo = "metis";
    rev = "f0b1a17cd57eb098077e963ab092477aee9fb340";
    sha256 = "1i7paax7b4byk8110f5zk4071mh5603r82bq7hbprqzljvsiipk7";
  };

  nativeBuildInputs = [ perl ];
  buildInputs = [ mlton ];

  patchPhase = "patchShebangs .";

  buildPhase = "make mlton";

  installPhase = ''
    install -Dm0755 bin/mlton/metis $out/bin/metis
  '';

  meta = with stdenv.lib; {
    description = "Automatic theorem prover for first-order logic with equality";
    homepage = http://www.gilith.com/research/metis/;
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
  };
}
