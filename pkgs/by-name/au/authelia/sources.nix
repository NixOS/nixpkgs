{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.22";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-6mKS+U0Leac2vcHRTMIAKfqr78NQUCMBiW76z4H/STw=";
  };
  vendorHash = "sha256-8ftsYIEMkoM3emW0d6E3cOv3hUQDLZcSBDEy8NvwNcY=";
  pnpmDepsHash = "sha256-ngHVlFIQuUY+D54CDZ7FIlu13UjGr3zcdTvKryntVhQ=";
}
