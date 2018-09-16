{ stdenv, fetchFromGitHub, postgresql, openssl } :

stdenv.mkDerivation rec {
  name = "pgmanage-${version}";
  version = "10.3.1";

  src = fetchFromGitHub {
    owner  = "pgManage";
    repo   = "pgManage";
    rev    = "v${version}";
    sha256 = "0ym1arla9wfkmr5n6h6dfyd680vlnng5s5j5nyxi2gl2wxqqhxzz";
  };

  patchPhase = ''
    patchShebangs src/configure
  '';

  configurePhase = ''
    ./configure --prefix $out
  '';

  buildInputs = [ postgresql openssl ];

  meta = with stdenv.lib; {
    description = "A fast replacement for PGAdmin";
    longDescription = ''
      At the heart of pgManage is a modern, fast, event-based C-binary, built in
      the style of NGINX and Node.js. This heart makes pgManage as fast as any
      PostgreSQL interface can hope to be. (Note: pgManage replaces Postage,
      which is no longer maintained.)
    '';
    homepage = https://github.com/pgManage/pgManage;
    license = licenses.postgresql;
    maintainers = [ maintainers.basvandijk ];
  };
}
