{ stdenv, lib, fetchFromGitHub, makeWrapper
, curl, netcat, python, bind, iproute, bc, gitMinimal }:
let
  version = "1.17.3";
  deps = lib.makeBinPath [
    curl
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
    sha256 = "1xdjk8bjh7l6h7gdqrra1dh4wdq89wmd0jsirsvqa3bmcsb2wz1r";
  };

  buildInputs = [ makeWrapper ];

  patchPhase = ''
    patchShebangs install.sh
    substituteInPlace install.sh --replace /usr/local "$out"
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out"/bin "$out"/share/man/man1
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
