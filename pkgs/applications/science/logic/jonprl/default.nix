{ fetchgit, stdenv, smlnj, which }:

stdenv.mkDerivation rec {
  name    = "jonprl-${version}";
  version = "0.1.0";

  src = fetchgit {
    url = "https://github.com/jonsterling/JonPRL.git";
    deepClone = true;
    rev = "refs/tags/v${version}";
    sha256 = "09m1vb41vxvqnk78gm9inip1abknkywij30rghvym93q460cl2hm";
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
