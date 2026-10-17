{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  callPackage,
}:

buildNpmPackage rec {
  pname = "doctoc";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "thlorenz";
    repo = "doctoc";
    rev = "v${version}";
    hash = "sha256-EmTZLy/eHtJ0Wi8EFP2lHdFKBut/8/aghRKZr1WHcNk=";
  };

  npmDepsHash = "sha256-rY9acsWMcR6cf9k0/rSoBvhuk96Yj8Yt8uhsC8dyQZU=";

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
