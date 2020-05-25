{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "cadical";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "arminbiere";
    repo = "cadical";
    rev = "rel-${version}";
    hash = "sha256:1a66xkw42ad330fvw8i0sawrmg913m8wrq5c85lw5qandkwvxdi6";
  };

  dontAddPrefix = true;
  installPhase = ''
    install -Dm0755 build/cadical "$out/bin/cadical"
    install -Dm0755 build/mobical "$out/bin/mobical"
    mkdir -p "$out/share/doc/${pname}-${version}/"
    install -Dm0755 {LICEN?E,README*,VERSION} "$out/share/doc/${pname}-${version}/"
  '';

  meta = with stdenv.lib; {
    description = "Simplified Satisfiability Solver";
    maintainers = with maintainers; [ shnarazk ];
    platforms = platforms.unix;
    license = licenses.mit;
    homepage = "http://fmv.jku.at/cadical";
  };
}
