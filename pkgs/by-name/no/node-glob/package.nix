{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "glob";
  version = "14.0.6";

  src = fetchFromGitHub {
    owner = "isaacs";
    repo = "node-glob";
    rev = "v${version}";
    hash = "sha256-L16vkXE504rT3mvxjN4Fby0YySyseE3EmhPw+YFuYpE=";
  };

  npmDepsHash = "sha256-CUWSyg+w8XeXEg0ED55X1YK3UCF46SO58qjPsuC+9Ns=";

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/isaacs/node-glob/blob/${src.rev}/changelog.md";
    description = "Little globber for Node.js";
    homepage = "https://github.com/isaacs/node-glob";
    license = lib.licenses.isc;
    mainProgram = "glob";
    maintainers = [ ];
  };
}
