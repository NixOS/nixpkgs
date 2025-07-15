{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "resumed";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "rbardini";
    repo = "resumed";
    rev = "v${version}";
    hash = "sha256-kDv6kOVY8IfztmLeby2NgB5q0DtP1ajMselvr1EDQJ8=";
  };

  npmDepsHash = "sha256-7Wdf8NaizgIExeX+Kc8wn5f20al0bnxRpFoPy6p40jw=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Lightweight JSON Resume builder, no-frills alternative to resume-cli";
    homepage = "https://github.com/rbardini/resumed";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
    mainProgram = "resumed";
  };
}
