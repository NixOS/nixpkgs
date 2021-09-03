{ lib, gccStdenv, fetchFromGitHub, ncurses }:

gccStdenv.mkDerivation rec {
  pname = "programmer-calculator";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "alt-romes";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vvpbj24ijl9ma0h669n9x0z1im3vqdf8zf2li0xf5h97b14gmv0";
  };

  buildInputs = [ ncurses ];

  installPhase = ''
    runHook preInstall
    install -Dm 555 pcalc -t "$out/bin"
    runHook postInstall
  '';

  meta = with lib; {
    description = "A terminal calculator for programmers";
    longDescription = ''
      Terminal calculator made for programmers working with multiple number
      representations, sizes, and overall close to the bits
    '';
    homepage = "https://alt-romes.github.io/programmer-calculator";
    changelog = "https://github.com/alt-romes/programmer-calculator/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ cjab ];
    platforms = platforms.all;
  };
}
