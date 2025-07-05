{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  callPackage,
}:

buildNpmPackage rec {
  pname = "doctoc";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "thlorenz";
    repo = "doctoc";
    rev = "v${version}";
    hash = "sha256-LYVxW8bZ4M87CmBvPyp4y0IeL9UFawwAKnUWHEWB5Gs=";
  };

  npmDepsHash = "sha256-TbAnFpiN/v6xjQQznL/B180f0W48HPRqW21cO9XZhYA=";

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
