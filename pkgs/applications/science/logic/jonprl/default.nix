{ fetchFromGitHub, stdenv, smlnj, which }:

stdenv.mkDerivation rec {
  name    = "jonprl-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jonsterling";
    repo = "JonPRL";
    deepClone = true;
    rev = "refs/tags/v${version}";
    sha256 = "1c6yc3kmcqlqpkbfi267rznkrn7cfi8mab2y8l8qykvx5wsj5b30";
  };

  buildInputs = [ smlnj which ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp bin/.heapimg.* "$out/bin/"
    build/mkexec.sh "${smlnj}/bin/sml" "$out" jonprl
  '';

  meta = {
    description = "Proof Refinement Logic - Computational Type Theory";
    longDescription = ''
      An proof refinement logic for computational type theory
      based on Brouwer-realizability & meaning explanations.
      Inspired by Nuprl
    '';
    homepage = http://www.jonprl.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ puffnfresh ];
    platforms = stdenv.lib.platforms.unix;
  };
}
