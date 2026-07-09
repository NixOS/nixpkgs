{
  buildRustyV8,
  fetchFromGitHub,
}:

buildRustyV8 rec {
  version = "146.9.0";
  src = fetchFromGitHub {
    owner = "denoland";
    repo = "rusty_v8";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-7nmt+gQDwJS+Xz4yfbBAPlEn7gx+sxIPyTyy5BPF2tQ=";
  };
  cargoHash = "sha256-iqJ9xLHXsMgJu2HzIlA8/GrI9Q7bUg2NsuA/8hsNkQk=";
}
