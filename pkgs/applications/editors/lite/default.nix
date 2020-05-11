{ stdenv, fetchFromGitHub, SDL2 }:

stdenv.mkDerivation rec {
  pname = "lite";
  version = "1.03";

  src = fetchFromGitHub {
    owner = "rxi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h8z4fav5ns9sm92axs3k9v6jgkqq0vg9mixza14949blr426mlj";
  };

  buildInputs = [ SDL2 ];

  buildPhase = "${stdenv.shell} build.sh";
  installPhase = "install -Dm 755 lite $out/bin/lite";

  meta = with stdenv.lib; {
    description = "A lightweight text editor written in Lua";
    homepage = "https://github.com/rxi/lite";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
