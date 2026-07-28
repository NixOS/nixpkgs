{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fzy";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "jhawthorn";
    repo = "fzy";
    rev = finalAttrs.version;
    sha256 = "sha256-ZGAt8rW21WFGuf/nE44ZrL68L/RmTYCBzuXWhidqJB8=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Better fuzzy finder";
    homepage = "https://github.com/jhawthorn/fzy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dywedir ];
    platforms = lib.platforms.all;
    mainProgram = "fzy";
  };
})
