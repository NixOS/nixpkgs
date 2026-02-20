{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  callPackage,
}:

buildNpmPackage rec {
  pname = "doctoc";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "thlorenz";
    repo = "doctoc";
    rev = "v${version}";
    hash = "sha256-I5k7P4O/RT/7Kja4nTgzkZurNUrdLpbe0eSqqMzYPz4=";
  };

  npmDepsHash = "sha256-9q9yH/yG/+SlZZjx3ZlLbAYRasPLavuMmPw5GenPG8o=";

  postInstall = ''
    find $out/lib/node_modules -xtype l -delete
  '';

  dontNpmBuild = true;

  passthru.tests = {
    generates-valid-markdown = callPackage ./test-generates-valid-markdown { };
  };

  meta = {
    description = "Generate table of contents for Markdown files";
    homepage = "https://github.com/thlorenz/doctoc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomodachi94 ];
    mainProgram = "doctoc";
    platforms = lib.platforms.all;
  };
}
