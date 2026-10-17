{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "html-minifier";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "kangax";
    repo = "html-minifier";
    rev = "v${version}";
    hash = "sha256-OAykAqBxgr7tbeXXfSH23DALf7Eoh3VjDKNKWGAL3+A=";
  };

  npmDepsHash = "sha256-VWXc/nBXgvSE/DoLHR4XTFQ5kuwWC1m0/cj1CndfPH8=";

  npmFlags = [ "--ignore-scripts" ];

  postInstall = ''
    find $out/lib/node_modules -xtype l -delete
  '';

  dontNpmBuild = true;

  meta = {
    description = "Highly configurable, well-tested, JavaScript-based HTML minifier";
    homepage = "https://github.com/kangax/html-minifier";
    license = lib.licenses.mit;
    mainProgram = "html-minifier";
    maintainers = with lib.maintainers; [ chris-martin ];
  };
}
