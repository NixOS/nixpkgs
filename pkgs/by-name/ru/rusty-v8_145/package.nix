{
  buildRustyV8,
  fetchFromGitHub,
}:

buildRustyV8 rec {
  version = "145.0.0";
  src = fetchFromGitHub {
    owner = "denoland";
    repo = "rusty_v8";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-uFB5Ao92c4tTTpEli5se8I9fvBrNHrDV3sbxJDokp/M=";
  };
  cargoHash = "sha256-YlEn1fUmIELz+80EMM4fc2BWG0y/700SIiNs8GIOtoY=";
}
