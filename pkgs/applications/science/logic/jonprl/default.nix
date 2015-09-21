{ fetchgit, stdenv, smlnj, which }:

stdenv.mkDerivation rec {
  name    = "jonprl-${version}";
  version = "0.1.0";

  src = fetchgit {
    url = "https://github.com/jonsterling/JonPRL.git";
    deepClone = true;
    rev = "refs/tags/v${version}";
    sha256 = "1z0d8dq1nb4dycic58nnk617hbfgafz0vmwr8gkl0i6405gfg1zy";
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
