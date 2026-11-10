{
  lib,
  stdenv,
  fetchFromGitHub,
  perlPackages,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shocco";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "rtomayko";
    repo = "shocco";
    rev = finalAttrs.version;
    sha256 = "1nkwcw9fqf4vyrwidqi6by7nrmainkjqkirkz3yxmzk6kzwr38mi";
  };

  prePatch = ''
    # Don't change $PATH
    substituteInPlace configure --replace PATH= NIRVANA=
  '';

  buildInputs = [
    perlPackages.TextMarkdown
    python3.pkgs.pygments
  ];

  meta = {
    description = "Quick-and-dirty, literate-programming-style documentation generator for / in POSIX shell";
    mainProgram = "shocco";
    homepage = "https://rtomayko.github.io/shocco/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
