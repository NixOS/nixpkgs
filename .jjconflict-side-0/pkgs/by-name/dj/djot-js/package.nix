{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  installShellFiles,
}:

buildNpmPackage rec {
  pname = "djot-js";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "jgm";
    repo = "djot.js";
    rev = "@djot/djot@${version}";
    hash = "sha256-dQfjI+8cKqn4qLT9eUKfCP++BFCWQ/MmrlQNVRNCFuU=";
  };

  npmDepsHash = "sha256-FjrjwhVv2WRjbEga9w37lwz7KYgTTHGsoqt496Uq/0c=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage doc/djot.1
  '';

  meta = with lib; {
    description = "JavaScript implementation of djot";
    homepage = "https://github.com/jgm/djot.js";
    changelog = "https://github.com/jgm/djot.js/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "djot";
  };
}
