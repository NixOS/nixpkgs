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
    hash = "sha256-JSB3xYraQJS3RTUMPgePI+BV9CcNyVOuZ8fyFz5Nwck=";
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

  meta = {
    homepage = "https://github.com/ccontavalli/ssh-ident";
    description = "Start and use ssh-agent and load identities as necessary";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ telotortium ];
    platforms = with lib.platforms; unix;
    mainProgram = "ssh-ident";
  };
}
