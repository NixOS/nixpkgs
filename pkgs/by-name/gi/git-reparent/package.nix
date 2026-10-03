{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  git,
  gnused,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-reparent";
  version = "0-unstable-2017-09-03";

  src = fetchFromGitHub {
    owner = "MarkLodato";
    repo = "git-reparent";
    rev = "a99554a32524a86421659d0f61af2a6c784b7715";
    hash = "sha256-u0w3t4Z+oDSc7AH+FQ2a+gNRoF36LAg8VyQbfpvvHmw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -m755 -Dt $out/bin git-reparent
  '';

  postFixup = ''
    wrapProgram $out/bin/git-reparent --prefix PATH : "${
      lib.makeBinPath [
        git
        gnused
      ]
    }"
  '';

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Git command to recommit HEAD with a new set of parents";
    maintainers = [ ];
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    mainProgram = "git-reparent";
  };
})
