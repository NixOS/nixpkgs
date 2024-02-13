{ lib
, python3
, fetchFromGitHub
, nix-update-script
}:


python3.pkgs.buildPythonApplication rec {
  pname = "npm-lockfile-fix";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jeslie0";
    repo = "npm-lockfile-fix";
    rev = "v${version}";
    hash = "sha256-0EGPCPmCf6bxbso3aHCeJ1XBOpYp3jtMXv8LGdwrsbs=";
  };

  propagatedBuildInputs = [
    python3.pkgs.requests
  ];

  doCheck = false; # no tests

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "Add missing integrity and resolved fields to a package-lock.json file";
    mainProgram = "npm-lockfile-fix";
    license = lib.licenses.mit;
    maintainers = [ maintainers.lucasew ];
  };
}
