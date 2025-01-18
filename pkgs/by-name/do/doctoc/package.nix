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

  dontNpmBuild = true;

  passthru.tests = {
    generates-valid-markdown = callPackage ./test-generates-valid-markdown { };
  };

  meta = with lib; {
    description = "Generate table of contents for Markdown files";
    homepage = "https://github.com/thlorenz/doctoc";
    license = licenses.mit;
    maintainers = with maintainers; [ tomodachi94 ];
    mainProgram = "doctoc";
    platforms = platforms.all;
  };
}
