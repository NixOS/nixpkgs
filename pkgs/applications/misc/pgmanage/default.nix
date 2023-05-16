<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, postgresql, openssl, nixosTests } :
stdenv.mkDerivation rec {
  pname = "pgmanage";
  # The last release 11.0.1 from 2018 fails the NixOS test
  # probably because of PostgreSQL-12 incompatibility.
  # Fortunately the latest master does succeed the test.
  version = "unstable-2022-05-11";
=======
{ lib, stdenv, fetchFromGitHub, postgresql, openssl } :

stdenv.mkDerivation rec {
  pname = "pgmanage";
  version = "11.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner  = "pgManage";
    repo   = "pgManage";
<<<<<<< HEAD
    rev    = "a028604416be382d6d310bc68b4e7c3cd16020fb";
    sha256 = "sha256-ibCzZrqfbio1wBVFKB6S/wdRxnCc7s3IQdtI9txxhaM=";
=======
    rev    = "v${version}";
    sha256 = "1a1dbc32b3y0ph8ydf800h6pz7dg6g1gxgid4gffk7k58xj0c5yf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patchPhase = ''
    patchShebangs src/configure
  '';

  configurePhase = ''
    ./configure --prefix $out
  '';

  buildInputs = [ postgresql openssl ];

<<<<<<< HEAD
  passthru.tests.sign-in = nixosTests.pgmanage;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A fast replacement for PGAdmin";
    longDescription = ''
      At the heart of pgManage is a modern, fast, event-based C-binary, built in
      the style of NGINX and Node.js. This heart makes pgManage as fast as any
      PostgreSQL interface can hope to be. (Note: pgManage replaces Postage,
      which is no longer maintained.)
    '';
    homepage = "https://github.com/pgManage/pgManage";
    license = licenses.postgresql;
    maintainers = [ maintainers.basvandijk ];
  };
}
