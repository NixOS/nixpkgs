{ stdenv, lib, fetchFromGitHub, makeWrapper
, curl, python, bind, iproute, bc, gitMinimal }:
let
  version = "1.23.0";
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
  pname = "bashSnippets";
  inherit version;

  src = fetchFromGitHub {
    owner = "alexanderepstein";
    repo = "Bash-Snippets";
    rev = "v${version}";
    sha256 = "044nxgd3ic2qr6hgq5nymn3dyf5i4s8mv5z4az6jvwlrjnvbg8cp";
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
