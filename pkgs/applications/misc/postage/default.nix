{ stdenv, fetchFromGitHub, runCommand, postgresql, openssl } :

stdenv.mkDerivation rec {
  name = "postage-${version}";
  version = "3.2.17";

  src = fetchFromGitHub {
    owner  = "workflowproducts";
    repo   = "postage";
    rev    = "eV${version}";
    sha256 = "1c9ss5vx8s05cgw68z7y224qq8z8kz8rxfgcayd2ny200kqyn5bl";
  };

  buildInputs = [ postgresql openssl ];

  meta = with stdenv.lib; {
    description = "A fast replacement for PGAdmin";
    longDescription = ''
      At the heart of Postage is a modern, fast, event-based C-binary, built in
      the style of NGINX and Node.js. This heart makes Postage as fast as any
      PostgreSQL interface can hope to be.
    '';
    homepage = http://www.workflowproducts.com/postage.html;
    license = licenses.asl20;
    maintainers = [ maintainers.basvandijk ];
  };
}
