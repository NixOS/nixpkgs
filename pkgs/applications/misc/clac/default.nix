{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2017-04-16";
  name = "clac-${version}";

  src = fetchFromGitHub {
    owner = "soveran";
    repo = "clac";
    rev = "828600b01e80166bc435d4d73506f0c3e16f2459";
    sha256 = "08fhhvjrc7rn5fjjdqlallr76m6ybj3wm5gx407jbgfbky0fj7mb";
  };

  installPhase = ''
    PREFIX=$out make install
  '';

  meta = {
    homepage = "https://github.com/soveran/clac";
    description = "A command line, stack-based calculator with postfix notation";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
