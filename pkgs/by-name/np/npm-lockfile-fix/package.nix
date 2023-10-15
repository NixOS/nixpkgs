{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication {
  pname = "npm-lockfile-fix";
  version = "unstable-2023-10-15";

  src = fetchFromGitHub {
    owner = "jeslie0";
    repo = "npm-lockfile-fix";
    rev = "8a87bf9e325f8466f9e6b0c9fe45ef857131a902";
    hash = "sha256-0EGPCPmCf6bxbso3aHCeJ1XBOpYp3jtMXv8LGdwrsbs=";
  };

  propagatedBuildInputs = [
    python3Packages.requests
  ];

  meta = with lib; {
    description = "Add missing integrity and resolved fields to a package-lock.json file";
    homepage = "https://github.com/jeslie0/npm-lockfile-fix";
    license = licenses.mit;
    maintainers = with maintainers; [ felschr ];
  };
}
