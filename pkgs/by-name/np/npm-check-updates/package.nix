{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "npm-check-updates";
  version = "17.1.15";

  src = fetchFromGitHub {
    owner = "raineorshine";
    repo = "npm-check-updates";
    rev = "refs/tags/v${version}";
    hash = "sha256-NewFg7eKhBMgMrjLQ1/n+CytcOZEaMMr/PNgA57Irw8=";
  };

  npmDepsHash = "sha256-qF3p+P+CJvpDhx0ddPnz6A7N9yC9+6uXWQCWFo9k30c=";

  postPatch = ''
    sed -i '/"prepare"/d' package.json
  '';

  makeCacheWritable = true;

  meta = {
    changelog = "https://github.com/raineorshine/npm-check-updates/blob/${src.rev}/CHANGELOG.md";
    description = "Find newer versions of package dependencies than what your package.json allows";
    homepage = "https://github.com/raineorshine/npm-check-updates";
    license = lib.licenses.asl20;
    mainProgram = "ncu";
    maintainers = with lib.maintainers; [ flosse ];
  };
}
