{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  python3,
  openssh,
}:

stdenvNoCC.mkDerivation {
  pname = "ssh-ident";
  version = "2016-04-21";
  src = fetchFromGitHub {
    owner = "ccontavalli";
    repo = "ssh-ident";
    rev = "ebf8282728211dc4448d50f7e16e546ed03c22d2";
    sha256 = "1jf19lz1gwn7cyp57j8d4zs5bq13iw3kw31m8nvr8h6sib2pf815";
  };

  postPatch = ''
    substituteInPlace ssh-ident \
      --replace 'ssh-agent >' '${openssh}/bin/ssh-agent >'
  '';
  buildInputs = [ python3 ];

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 ssh-ident $out/bin/ssh-ident
  '';

  meta = with lib; {
    homepage = "https://github.com/ccontavalli/ssh-ident";
    description = "Start and use ssh-agent and load identities as necessary";
    license = licenses.bsd2;
    maintainers = with maintainers; [ telotortium ];
    platforms = with platforms; unix;
    mainProgram = "ssh-ident";
  };
}
