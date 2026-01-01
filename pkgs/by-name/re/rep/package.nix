{
  lib,
  stdenv,
  fetchFromGitHub,
  asciidoc-full,
}:

stdenv.mkDerivation rec {
  pname = "rep";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "eraserhd";
    repo = "rep";
    rev = "v${version}";
    sha256 = "pqmISVm3rYGxRuwKieVpRwXE8ufWnBHEA6h2hrob51s=";
  };

  nativeBuildInputs = [
    asciidoc-full
  ];

  postPatch = ''
    substituteInPlace rc/rep.kak --replace '$(rep' '$('"$out/bin/rep"
  '';
  makeFlags = [ "prefix=$(out)" ];

<<<<<<< HEAD
  meta = {
    description = "Single-shot nREPL client";
    mainProgram = "rep";
    homepage = "https://github.com/eraserhd/rep";
    license = lib.licenses.epl10;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.eraserhd ];
=======
  meta = with lib; {
    description = "Single-shot nREPL client";
    mainProgram = "rep";
    homepage = "https://github.com/eraserhd/rep";
    license = licenses.epl10;
    platforms = platforms.all;
    maintainers = [ maintainers.eraserhd ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
