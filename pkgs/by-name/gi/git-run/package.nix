{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
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

  postInstall = ''
    echo "Removing broken symlinks in node_modules/.bin"
    rm -f $out/lib/node_modules/${pname}/node_modules/.bin/_mocha
    rm -f $out/lib/node_modules/${pname}/node_modules/.bin/he
    rm -f $out/lib/node_modules/${pname}/node_modules/.bin/mkdirp
    rm -f $out/lib/node_modules/${pname}/node_modules/.bin/mocha
    rm -f $out/lib/node_modules/${pname}/node_modules/.bin/rimraf
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multiple git repository management tool";
    homepage = "https://mixu.net/gr/";
    license = lib.licenses.bsd3;
    mainProgram = "gr";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
