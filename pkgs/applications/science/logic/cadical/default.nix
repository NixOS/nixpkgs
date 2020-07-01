{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "cadical";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "arminbiere";
    repo = "cadical";
    rev = "rel-${version}";
    sha256 = "05lvnvapjawgkky38xknb9lgaliiwan4kggmb9yggl4ifpjrh8qf";
  };

  doCheck = true;
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
