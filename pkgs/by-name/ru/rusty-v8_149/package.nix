{
  buildRustyV8,
  fetchFromGitHub,
}:

buildRustyV8 rec {
  version = "149.4.0";
  src = fetchFromGitHub {
    owner = "denoland";
    repo = "rusty_v8";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-n4dKtki9ov0lWBeLmMDI4Tpk8zQ8YYSf04QW6DTYisY=";
  };
  cargoHash = "sha256-bGqg/6sfBaF/JpObgXyP4Mh+4P9zfuzd454m4wjluGw=";
}
