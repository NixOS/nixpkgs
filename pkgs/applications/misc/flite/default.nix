{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "flite-1.3-release";

  src = fetchurl {
    url = http://www.speech.cs.cmu.edu/flite/packed/flite-1.3/flite-1.3-release.tar.gz;
    sha256 = "12wanxx57bbqgkag54dlqzv6h2kr9053p0z8mkxs0mqy03vja8lj";
  };

  buildPhase =
    ''
      unset buildPhase
      ensureDir $out/lib
      buildPhase
    '';

  installPhase =
    ''
      ensureDir $out/share/flite
      cp -r bin $out
    '';

  meta = { 
    description = "Flite text to speech engine";
    homepage = http://www.speech.cs.cmu.edu/flite/download.html;
    license = "BSD as-is";
  };
}
