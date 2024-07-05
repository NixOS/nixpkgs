{
  lib,
  mkYarnPackage,
  fetchYarnDeps,
  fetchFromGitHub,
  nodejs_22
}: mkYarnPackage rec {
  pname = "get-graphql-schema";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "prisma-labs";
    repo = "get-graphql-schema";
    rev = "v${version}";
    hash = "sha256-ujc0LGAqmo4SmItm4VcbBOtmUvL6aV1ppMm4fMmuSRs=";
  };

  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-TZGNX8UHbolLyBmQNGTnFjgx3/3f2HNVQf/h9rIVJKs=";
  };

  buildPhase = ''
    runHook preBuild
    yarn --offline build
    runHook postBuild
  '';

  postFixup = ''
    substituteInPlace $out/libexec/get-graphql-schema/deps/get-graphql-schema/dist/index.js \
      --replace-fail "#!/usr/bin/env node" "#!${lib.getExe nodejs_22}"
    chmod +x $out/bin/get-graphql-schema
  '';
  meta = {
    description = "Command line tool for generating a changelog from git tags and commit history";
    homepage = "https://github.com/cookpete/auto-changelog";
    changelog = "https://github.com/cookpete/auto-changelog/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "get-graphql-schema";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
