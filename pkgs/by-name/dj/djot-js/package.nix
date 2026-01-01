{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  installShellFiles,
}:

buildNpmPackage rec {
  pname = "djot-js";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "jgm";
    repo = "djot.js";
    rev = "@djot/djot@${version}";
    hash = "sha256-SkE7ssWC62sYZNshB8ncfMVI4NEyEbzO5IVIDsKtynU=";
  };

  npmDepsHash = "sha256-FjrjwhVv2WRjbEga9w37lwz7KYgTTHGsoqt496Uq/0c=";

  nativeBuildInputs = [
    installShellFiles
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    npm run test

    runHook postCheck
  '';

  postInstall = ''
    installManPage doc/djot.1
  '';

<<<<<<< HEAD
  meta = {
    description = "JavaScript implementation of djot";
    homepage = "https://github.com/jgm/djot.js";
    changelog = "https://github.com/jgm/djot.js/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "JavaScript implementation of djot";
    homepage = "https://github.com/jgm/djot.js";
    changelog = "https://github.com/jgm/djot.js/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = with lib.maintainers; [ rpqt ];
    mainProgram = "djot";
  };
}
