{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "antfs-cli";
  version = "0-unstable-2017-02-11";
  format = "pyproject";

  meta = with lib; {
    homepage = "https://github.com/Tigge/antfs-cli";
    description = "Extracts FIT files from ANT-FS based sport watches";
    mainProgram = "antfs-cli";
    license = licenses.mit;
    platforms = platforms.linux;
  };

  src = fetchFromGitHub {
    owner = "Tigge";
    repo = "antfs-cli";
    rev = "85a6cc6fe6fc0ec38399f5aa30fb39177c565b52";
    sha256 = "0v8y64kldfbs809j1g9d75dd1vxq7mfxnp4b45pz8anpxhjf64fy";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.openant ];
}
