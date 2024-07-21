{
  binutils-unwrapped, # strings
  coreutils,
  getent, # /etc/passwd
  fetchFromGitHub,
  findutils,
  lib,
  makeWrapper,
  ncurses, # tput
  ruby,
  stdenv,
}:

# No gems used, so mkDerivation is fine.
let
  additionalPath = lib.makeBinPath [
    getent
    ncurses
    binutils-unwrapped
    coreutils
    findutils
  ];
in
stdenv.mkDerivation rec {
  pname = "nix-top";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "jerith666";
    repo = "nix-top";
    rev = "v${version}";
    hash = "sha256-w/TKzbZmMt4CX2KnLwPvR1ydp5NNlp9nNx78jJvhp54=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ ruby ];

  installPhase =
    ''
      runHook preInstall
      mkdir -p $out/libexec/nix-top
      install -D -m755 ./nix-top $out/bin/nix-top
      wrapProgram $out/bin/nix-top \
        --prefix PATH : "$out/libexec/nix-top:${additionalPath}"
    ''
    + lib.optionalString stdenv.isDarwin ''
      ln -s /bin/stty $out/libexec/nix-top
    ''
    + ''
      runHook postInstall
    '';

  meta = {
    description = "Tracks what nix is building";
    homepage = "https://github.com/jerith666/nix-top";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jerith666 ];
    platforms = lib.platforms.unix;
    mainProgram = "nix-top";
  };
}
