{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  wxGTK32,
  boost,
  firebird,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.9.14";
  pname = "flamerobin";

  src = fetchFromGitHub {
    owner = "mariuz";
    repo = "flamerobin";
    tag = "${finalAttrs.version}";
    hash = "sha256-IwJEFF3vP0BC9PoMoY+XPLT+ygXnFXP/TWaqjdQWs8s=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    wxGTK32
    boost
    firebird
  ];

  meta = {
    description = "Database administration tool for Firebird RDBMS";
    homepage = "https://github.com/mariuz/flamerobin";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ uralbash ];
    platforms = lib.platforms.unix;
    mainProgram = "flamerobin";
  };
})
