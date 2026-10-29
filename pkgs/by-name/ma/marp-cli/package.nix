{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:

buildNpmPackage (finalAttrs: {
  pname = "marp-cli";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "marp-team";
    repo = "marp-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MJALb8rH0xwFUa9KLq/zKuSJmbGum2aMFwx1AzDnCLA=";
  };

  npmDepsHash = "sha256-C9lssV3yOZJV3BHZ1MqDxFCT3PkYjjAyHTjQ/32ps3c=";
  npmPackFlags = [ "--ignore-scripts" ];
  makeCacheWritable = true;

  doCheck = false;

  meta = {
    description = "About A CLI interface for Marp and Marpit based converters";
    homepage = "https://github.com/marp-team/marp-cli";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = nodejs.meta.platforms;
    mainProgram = "marp";
  };
})
