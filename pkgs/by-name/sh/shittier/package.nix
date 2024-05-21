{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "shittier";
  # No tagged release on GitHub yet
  # Commit corresponds to release tagged as 0.1.1 on [npm](https://www.npmjs.com/package/shittier)
  # See issue https://github.com/rohitdhas/shittier/issues/7
  version = "0-unstable-2023-12-22";

  src = fetchFromGitHub {
    owner = "rohitdhas";
    repo = "shittier";
    rev = "c61b443c06dbaa8085a88b16360941cc4ba6baa2";
    hash = "sha256-qdG1PdIZGWoJI7KgJqM/fayubPbPk+od/SgKfZQADz8=";
  };

  npmDepsHash = "sha256-oC9eOpoMZLZbyx9XnC4m5zzqORQWP62uRDNVZjyVnBs=";

  meta = {
    description = "Unconventional code formatting tool for JavaScript";
    mainProgram = "shittier";
    homepage = "https://github.com/rohitdhas/shittier";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ totoroot ];
  };
}
