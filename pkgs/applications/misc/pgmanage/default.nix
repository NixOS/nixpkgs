{ stdenv, fetchFromGitHub, runCommand, postgresql, openssl } :

stdenv.mkDerivation rec {
  name = "pgmanage-${version}";
  version = "10.0.2";

  src = fetchFromGitHub {
    owner  = "pgManage";
    repo   = "pgManage";
    rev    = "v${version}";
    sha256 = "0g9kvhs9b6kc1s7j90fqv71amiy9v0w5p906yfvl0j7pf3ayq35a";
  };

  buildInputs = [ postgresql openssl ];

  meta = with stdenv.lib; {
    description = "A fast replacement for PGAdmin";
    longDescription = ''
      At the heart of Postage is a modern, fast, event-based C-binary, built in
      the style of NGINX and Node.js. This heart makes Postage as fast as any
      PostgreSQL interface can hope to be.
    '';
    homepage = https://github.com/pgManage/pgManage;
    license = licenses.postgresql;
    maintainers = [ maintainers.basvandijk ];
  };
}
