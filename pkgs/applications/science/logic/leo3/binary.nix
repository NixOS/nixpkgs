{stdenv, fetchurl, openjdk}:
stdenv.mkDerivation rec {
  pname = "leo3";
  version = "1.2";

  jar = fetchurl {
    url = "https://github.com/leoprover/Leo-III/releases/download/v${version}/leo3.jar";
    sha256 = "1lgwxbr1rnk72rnvc8raq5i1q71ckhn998pwd9xk6zf27wlzijk7";
  };

  phases=["installPhase" "fixupPhase"];

  installPhase = ''
    mkdir -p "$out"/{bin,lib/java/leo3}
    cp "${jar}" "$out/lib/java/leo3/leo3.jar"
    echo "#!${stdenv.shell}" > "$out/bin/leo3"
    echo "'${openjdk}/bin/java' -jar '$out/lib/java/leo3/leo3.jar' \"\$@\""  > "$out/bin/leo3"
    chmod a+x "$out/bin/leo3"
  '';

  meta = {
    inherit version;
    description = "An automated theorem prover for classical higher-order logic with choice";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "https://page.mi.fu-berlin.de/lex/leo3/";
  };
}
