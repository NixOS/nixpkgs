{
  lib,
  buildNpmPackage,
  fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "git-run";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "mixu";
    repo = "gr";
    rev = "v${version}";
    hash = "sha256-WPnar87p0GYf6ehhVEUeZd2pTjS95Zl6NpiJuIOQ5Tc=";
  };

  npmDepsHash = "sha256-PdxKFopmuNRWkSwPDX1wcNTvRtbVScl1WsZi7sdkKMw=";

  makeCacheWritable = true;
  dontBuild = true;

  meta = {
    description = "Multiple git repository management tool";
    homepage = "https://mixu.net/gr/";
    license = lib.licenses.bsd3;
    mainProgram = "gr";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
