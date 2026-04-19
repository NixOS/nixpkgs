{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  callPackage,
}:

buildNpmPackage rec {
  pname = "doctoc";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "thlorenz";
    repo = "doctoc";
    rev = "v${version}";
    hash = "sha256-jLYzp0jKqePC6rjvLWNyrI+VEkuiRgk9PeME6TTxATE=";
  };

  npmDepsHash = "sha256-4QjEi/cc3UFXQ4xTfIowLO5rEmUoBkSw4oNuaeiuK1s=";

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
