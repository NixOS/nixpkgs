{ lib, fetchFromGitHub, stdenvNoCC, w3m, curl, jq, makeWrapper, installShellFiles }:

stdenvNoCC.mkDerivation rec {
  pname = "tmpmail";
  version = "1.1.4";

   src = fetchFromGitHub {
    owner = "sdushantha";
    repo = "tmpmail";
    rev = "v${version}";
    sha256 = "sha256-Rcu1qNmUZhMRvPiaWrDlzLtGksv09XBiF2GJUxXKs1Y=";
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
