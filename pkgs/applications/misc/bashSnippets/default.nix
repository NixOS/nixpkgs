{ stdenv, lib, fetchFromGitHub, makeWrapper
, curl, netcat, mpv, python, bind, iproute, bc, gitMinimal }:
let
  version = "1.12.0";
  deps = lib.makeBinPath [
    curl
    mpv
    python
    bind.dnsutils
    iproute
    bc
    gitMinimal
  ];
in
stdenv.mkDerivation {
  name = "bashSnippets-${version}";

  src = fetchFromGitHub {
    owner = "alexanderepstein";
    repo = "Bash-Snippets";
    rev = "v${version}";
    sha256 = "0kx2a8z3jbmmardw9z8fpghbw5mrbz4knb3wdihq35iarcbrddrg";
  };

  buildInputs = [ makeWrapper ];

  patchPhase = ''
    patchShebangs install.sh
    substituteInPlace install.sh --replace /usr/local "$out"
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out"/bin "$out"/man/man1
    ./install.sh all
    for file in "$out"/bin/*; do
      wrapProgram "$file" --prefix PATH : "${deps}"
    done
  '';

  meta = with lib; {
    description = "A collection of small bash scripts for heavy terminal users";
    homepage = https://github.com/alexanderepstein/Bash-Snippets;
    license = licenses.mit;
    maintainers = with maintainers; [ infinisil ];
    platforms = platforms.unix;
  };
}
