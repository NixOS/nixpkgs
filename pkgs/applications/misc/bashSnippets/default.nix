{ stdenv, fetchFromGitHub
, curl, netcat, mpv, python, bind, iproute, bc, gitMinimal, ... }:
let
  version = "1.12.0";
in
stdenv.mkDerivation {
  name = "bashSnippets-${version}";

  src = fetchFromGitHub {
    owner = "alexanderepstein";
    repo = "Bash-Snippets";
    rev = "v${version}";
    sha256 = "0kx2a8z3jbmmardw9z8fpghbw5mrbz4knb3wdihq35iarcbrddrg";
  };

  propagatedBuildInputs = [
    curl
    mpv
    python
    bind.dnsutils
    iproute
    bc
    gitMinimal
  ];

  patchPhase = ''
    patchShebangs install.sh
    substituteInPlace install.sh --replace /usr/local "$out"
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/bin" "$out/man"
    ./install.sh all
  '';

  outputs = [ "out" "man" ];

  meta = with stdenv.lib; {
    description = "A collection of small bash scripts for heavy terminal users";
    homepage = https://github.com/alexanderepstein/Bash-Snippets;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
