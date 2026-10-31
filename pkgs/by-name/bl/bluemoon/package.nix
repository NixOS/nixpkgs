{
  lib,
  stdenv,
  fetchFromGitLab,
  ncurses,
  asciidoctor,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bluemoon";
  version = "2.15";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "bluemoon";
    tag = finalAttrs.version;
    hash = "sha256-3CNeiA7K8JkBXTYzq787QgVHfVvYXZ/0uRqVCZ5mMZo=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [ asciidoctor ];

  buildInputs = [ ncurses ];

  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    make bluemoon.6
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ncurses based solitaire TUI card game";
    homepage = "https://gitlab.com/esr/bluemoon";
    mainProgram = "bluemoon";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
