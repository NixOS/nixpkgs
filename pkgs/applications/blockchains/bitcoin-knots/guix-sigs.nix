{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  name = "guix-sigs";
  version = "2025-07-12";

  src = fetchFromGitHub {
    owner = "bitcoinknots";
    repo = "guix.sigs";
    rev = "b24490e41000ecc044549ee499c2b10399953a37";
    hash = "sha256-R/Y3le8tefHtegCEEGJlIcy/x2vFtbTyMDL3AclBwds=";
  };

  buildPhase = ''
    mkdir $out
    cp builder-keys/* $out/
  '';
}
