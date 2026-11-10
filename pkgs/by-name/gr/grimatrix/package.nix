{
  lib,
  stdenv,
  fetchFromGitea,
  cmake,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "grimatrix";
  version = "1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "b6d5b38e0d7ae6bd0d951815cd92df43";
    repo = "grimatrix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SwTs9wNKLBHyAgdUrfN288FrAu3wrbjATVJc4UsGTP4=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ ncurses ];

  postPatch = ''
    substituteInPlace src/main.cpp \
      --replace-fail "/usr/share/grimatrix/" "$out/share/grimatrix/"
  '';

  meta = {
    description = "Warhammer CLI application screen waster inspired by cmatrix";
    homepage = "https://codeberg.org/b6d5b38e0d7ae6bd0d951815cd92df43/grimatrix";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ b6d5b38e0d7ae6bd0d951815cd92df43 ];
    mainProgram = "grimatrix";
    platforms = lib.platforms.all;
  };
})
