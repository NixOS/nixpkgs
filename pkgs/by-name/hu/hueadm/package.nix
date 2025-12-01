{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "hueadm";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "bahamas10";
    repo = "hueadm";
    tag = "v${version}";
    hash = "sha256-QNjkfE8V/lUkYP8NAf11liKXILBk3wSNm3NSrgaH+nc=";
  };

  npmDepsHash = "sha256-EbwHbPe8QvT6ekH20q+ihGmwpAHykwkwoJ6vwAf0FlA=";

  dontNpmBuild = true;

  meta = {
    description = "Command line management interface to Philips Hue";
    homepage = "https://github.com/bahamas10/hueadm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "hueadm";
  };
}
