{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "git-extras-${version}";
  version = "3.0.0";

  src = fetchurl {
    url = "https://github.com/tj/git-extras/archive/${version}.tar.gz";
    sha256 = "01x8n9i5sgl1s53sgglg9sd9lyp35dhvdhwlx03yimi4i11441s9";
  };

  phases = [ "unpackPhase" "installPhase" ];

  makeFlags = "DESTDIR=$(out) PREFIX=";

  meta = with stdenv.lib; {
    homepage = https://github.com/tj/git-extras;
    description = "GIT utilities -- repo summary, repl, changelog population, author commit percentages and more";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.spwhitt ];
  };
}
