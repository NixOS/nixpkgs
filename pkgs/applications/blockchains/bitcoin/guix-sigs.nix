{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  name = "guix-sigs";
  version = "2025-07-12";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "guix.sigs";
    rev = "59b8afc56f9a2b94eee3042844ab9c15b93fbfe3";
    hash = "sha256-7xBpSFXmV3G6E/Lp2Io4Se6kL3qZ8lItXNFLU8NS7KM=";
  };

  buildPhase = ''
    mkdir $out
    cp builder-keys/* $out/
  '';
}
