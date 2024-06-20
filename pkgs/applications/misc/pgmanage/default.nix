{ lib, stdenv, fetchFromGitHub, postgresql, openssl, nixosTests } :
stdenv.mkDerivation rec {
  pname = "pgmanage";
  # The last release 11.0.1 from 2018 fails the NixOS test
  # probably because of PostgreSQL-12 incompatibility.
  # Fortunately the latest master does succeed the test.
  version = "unstable-2022-05-11";

  src = fetchFromGitHub {
    owner  = "pgManage";
    repo   = "pgManage";
    rev    = "a028604416be382d6d310bc68b4e7c3cd16020fb";
    sha256 = "sha256-ibCzZrqfbio1wBVFKB6S/wdRxnCc7s3IQdtI9txxhaM=";
  };

  patchPhase = ''
    patchShebangs src/configure
  '';

  configurePhase = ''
    ./configure --prefix $out
  '';

  buildInputs = [ postgresql openssl ];

  passthru.tests.sign-in = nixosTests.pgmanage;

  meta = with lib; {
    description = "Fast replacement for PGAdmin";
    longDescription = ''
      At the heart of pgManage is a modern, fast, event-based C-binary, built in
      the style of NGINX and Node.js. This heart makes pgManage as fast as any
      PostgreSQL interface can hope to be. (Note: pgManage replaces Postage,
      which is no longer maintained.)
    '';
    homepage = "https://github.com/pgManage/pgManage";
    license = licenses.postgresql;
    maintainers = [ maintainers.basvandijk ];
    mainProgram = "pgmanage";
  };
}
