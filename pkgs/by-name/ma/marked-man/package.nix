{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "marked-man";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "kapouer";
    repo = "marked-man";
    rev = version;
    hash = "sha256-RzPKahYxBdWZi1SwIv7Ju1cAQ4s0ANkCivFJItPYGCY=";
  };

  # https://github.com/kapouer/marked-man/issues/37
  prePatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  npmDepsHash = "sha256-8m0Xgq3O69hbSQArSrU/gbJvBEGP6rHK4to16QkXG6M=";

  dontNpmBuild = true;

  meta = {
    description = "Markdown to roff wrapper around marked";
    homepage = "https://github.com/kapouer/marked-man";
    changelog = "https://github.com/kapouer/marked-man/blob/${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ atemu ];
    mainProgram = "marked-man";
    platforms = lib.platforms.all;
  };
}
