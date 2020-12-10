{ stdenv, fetchgit, lua5_3 }:

stdenv.mkDerivation rec {
  pname = "quickscope-kak";
  version = "1.0.0";

  src = fetchgit {
    url = "https://git.sr.ht/~voroskoi/quickscope.kak";
    rev = "v${version}";
    sha256 = "0y1g3zpa2ql8l9rl5i2w84bka8a09kig9nq9zdchaff5pw660mcx";
  };

  buildInputs = [ lua5_3 ];

  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins/
    cp quickscope.* $out/share/kak/autoload/plugins/
    # substituteInPlace does not like the pipe
    sed -e 's,[|] *lua,|${lua5_3}/bin/lua,' quickscope.kak >$out/share/kak/autoload/plugins/quickscope.kak
  '';

  meta = with stdenv.lib; {
    description = "Highlight f and t jump positions";
    homepage = "https://sr.ht/~voroskoi/quickscope.kak/";
    license = licenses.unlicense;
    maintainers = with maintainers; [ eraserhd ];
    platforms = platforms.all;
  };
}
