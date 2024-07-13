{ lib, fetchFromGitHub, stdenvNoCC, w3m, curl, jq, makeWrapper, installShellFiles, xclip }:

stdenvNoCC.mkDerivation rec {
  pname = "tmpmail";
  version = "1.2.3";

   src = fetchFromGitHub {
    owner = "sdushantha";
    repo = "tmpmail";
    rev = "v${version}";
    sha256 = "sha256-s4c1M4YHK/CNpH7nPt7rRqlkLUZrpBXvAVS/qxCai9c=";
  };

  dontConfigure = true;

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 -t $out/bin tmpmail
    installManPage tmpmail.1
    wrapProgram $out/bin/tmpmail --prefix PATH : ${lib.makeBinPath [ w3m curl jq xclip ]}
  '';

   meta = with lib; {
    homepage = "https://github.com/sdushantha/tmpmail";
    description = "Temporary email right from your terminal written in POSIX sh ";
    license = licenses.mit;
    maintainers = [ maintainers.lom ];
    mainProgram = "tmpmail";
  };
}
