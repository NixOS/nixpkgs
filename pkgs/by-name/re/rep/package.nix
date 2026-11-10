{
  lib,
  stdenv,
  fetchFromGitHub,
  asciidoc-full,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rep";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "eraserhd";
    repo = "rep";
    rev = "v${finalAttrs.version}";
    sha256 = "pqmISVm3rYGxRuwKieVpRwXE8ufWnBHEA6h2hrob51s=";
  };

  nativeBuildInputs = [
    asciidoc-full
  ];

  postPatch = ''
    substituteInPlace rc/rep.kak --replace '$(rep' '$('"$out/bin/rep"
  '';
  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Single-shot nREPL client";
    mainProgram = "rep";
    homepage = "https://github.com/eraserhd/rep";
    license = lib.licenses.epl10;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.eraserhd ];
  };
})
