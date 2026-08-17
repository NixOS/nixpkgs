{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "jake";
  version = "10.9.1";

  src = fetchFromGitHub {
    owner = "jakejs";
    repo = "jake";
    rev = "v${version}";
    hash = "sha256-rYWr/ACr14/WE88Gk6Kpyl2pq1XRHSfZGXHrwbGC8hQ=";
  };

  npmDepsHash = "sha256-BwOfPRiVMpFo9tG9oY2r82w2g3y/7sL3PD5epd2igmI=";

  dontNpmBuild = true;

  meta = {
    description = "JavaScript build tool, similar to Make or Rake";
    homepage = "https://github.com/jakejs/jake";
    license = lib.licenses.asl20;
    mainProgram = "jake";
    maintainers = with lib.maintainers; [ jasoncarr ];
  };
}
