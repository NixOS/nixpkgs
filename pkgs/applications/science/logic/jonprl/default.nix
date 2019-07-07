{ fetchgit, stdenv, smlnj, which }:

stdenv.mkDerivation rec {
  name    = "jonprl-${version}";
  version = "0.1.0";

  src = fetchgit {
    url = "https://github.com/jonsterling/JonPRL.git";
    deepClone = true;
    rev = "refs/tags/v${version}";
    sha256 = "0czs13syvnw8fz24d075n4pmsyfs8rs8c7ksmvd7cgb3h55fvp4p";
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
    homepage = https://github.com/jonsterling/JonPRL;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ puffnfresh ];
    platforms = stdenv.lib.platforms.linux;
  };
}
