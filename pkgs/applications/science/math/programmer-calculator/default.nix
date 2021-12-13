{ lib, gccStdenv, fetchFromGitHub, ncurses }:

gccStdenv.mkDerivation rec {
  pname = "programmer-calculator";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "alt-romes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JQcYCYKdjdy8U2XMFzqTH9kAQ7CFv0r+sC1YfuAm7p8=";
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
