{
  lib,
  stdenv,
  fetchFromGitLab,

  ncurses,
}:
stdenv.mkDerivation {
  pname = "pond";
  version = "0-unstable-2025-01-03";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "alice-lefebvre";
    repo = "pond";
    rev = "6f7620940d896a1717e764da0b4b41c96362ac8d";
    hash = "sha256-qQxtEJHRMvR9hmpRbEBmKwuFjjb9FeGLY/LlHdHh+rI=";
  };

  buildInputs = [ ncurses ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "-lcurses" "-lncurses"
  '';

  installPhase = ''
    runHook preInstall;
    install -m555 -Dt $out/bin bin/pond
    runHook postInstall;
  '';

  meta = {
    homepage = "https://gitlab.com/alice-lefebvre/pond";
    description = "A software that simulates a little pond";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ wyspr ];
  };
}
