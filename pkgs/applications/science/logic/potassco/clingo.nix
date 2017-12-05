{stdenv, fetchurl, cmake}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "clingo";
  version = "5.2.2";

  src = fetchurl {
    url = "https://github.com/potassco/clingo/releases/v${version}.tar.gz";
    sha256 = "1kxzb385g8p9mqm1x9wvjrigifa09w6vj0wl7kradibm5qagh7ns";
  };

  buildInputs = [];
  nativeBuildInputs = [cmake];

  meta = {
    inherit version;
    description = "ASP system to ground and solve logic programs";
    license = stdenv.lib.licenses.mit;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "https://potassco.org/";
    downloadPage = "https://github.com/potassco/clingo/releases/";
  };
}
