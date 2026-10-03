{
  lib,
  stdenv,
  fetchFromGitHub,
  groff,
  installShellFiles,
  makeWrapper,
  ncurses,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lander";
  version = "0-unstable-2022-08-20";

  src = fetchFromGitHub {
    owner = "staceycampbell";
    repo = "lander";
    rev = "e30c175091f108efb7f70d3ae09766e7da3639ec";
    hash = "sha256-FIt/9F5pWbU0qFalRUEIMQXNnuora81vWN6pMNr/WKg=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-warn 'sudo ' "" \
      --replace-warn 'chown ' '# chown ' \
      --replace-warn '-lcurses' '-lncurses'
  '';

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    groff
    installShellFiles
    makeWrapper
  ];
  buildInputs = [ ncurses ];

  makeFlags = [
    "HSFILE=lander.hs"
    "BIN=${placeholder "out"}/bin"
  ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  # Store scores in the XDG state dir and install man page
  postInstall = ''
    mkdir $out/libexec
    mv $out/bin/lander $out/libexec/lander
    makeWrapper $out/libexec/lander $out/bin/lander --run \
      'set -e; state="''${XDG_STATE_HOME:-$HOME/.local/state}/lander"; mkdir -p "$state"; cd "$state"'

    installManPage lander.6
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Classic curses-based lunar lander arcade game";
    homepage = "https://github.com/staceycampbell/lander";
    license = lib.licenses.gpl2Only;
    mainProgram = "lander";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Zaczero ];
  };
})
