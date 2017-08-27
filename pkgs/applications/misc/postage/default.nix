{ stdenv, fetchFromGitHub, runCommand, postgresql, openssl } :

stdenv.mkDerivation rec {
  name = "postage-${version}";
  version = "3.2.18";

  src = fetchFromGitHub {
    owner  = "workflowproducts";
    repo   = "postage";
    rev    = "eV${version}";
    sha256 = "1kdg8pw2vxwkxw3b6dim4s740s60j3iyrh96524wi3lqkkq98krn";
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
