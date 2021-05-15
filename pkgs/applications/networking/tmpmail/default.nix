{ lib, fetchFromGitHub, stdenvNoCC, w3m, curl, jq, makeWrapper, installShellFiles }:

stdenvNoCC.mkDerivation rec {
  pname = "tmpmail";
  version = "unstable-2021-02-10";

   src = fetchFromGitHub {
    owner = "sdushantha";
    repo = "tmpmail";
    rev = "150b32083d36006cf7f496e112715ae12ee87727";
    sha256 = "sha256-yQ9/UUxBTEXK5z3f+tvVRUzIGrAnrqurQ0x56Ad7RKE=";
  };

  dontConfigure = true;

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 -t $out/bin tmpmail
    installManPage tmpmail.1
    wrapProgram $out/bin/tmpmail --prefix PATH : ${lib.makeBinPath [ w3m curl jq ]}
  '';

   meta = with lib; {
    homepage = "https://github.com/sdushantha/tmpmail";
    description = "A temporary email right from your terminal written in POSIX sh ";
    license = licenses.mit;
    maintainers = [ maintainers.legendofmiracles ];
  };
}
