{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  curl,
  python3,
  bind,
  iproute2,
  bc,
  gitMinimal,
}:
let
  deps = lib.makeBinPath [
    curl
    python3
    bind.dnsutils
    iproute2
    bc
    gitMinimal
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bash-snippets";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "alexanderepstein";
    repo = "Bash-Snippets";
    rev = "v${finalAttrs.version}";
    hash = "sha256-l6G3tpWZ8i3NV+SXXZEmsTjfhq3eFvygyViwONrrlhA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    patchShebangs install.sh
    substituteInPlace install.sh --replace /usr/local "$out"
  '';

  strictDeps = true;

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out"/bin "$out"/share/man/man1
    ./install.sh all
    for file in "$out"/bin/*; do
      wrapProgram "$file" --prefix PATH : "${deps}"
    done
  '';

  meta = {
    description = "Collection of small bash scripts for heavy terminal users";
    homepage = "https://github.com/alexanderepstein/Bash-Snippets";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
