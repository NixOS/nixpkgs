{
  lib,
  fetchFromGitHub,
  python3Packages,
  pdk-ciel,
  libparse-python,
}:

python3Packages.buildPythonApplication {
  pname = "librelane";
  version = "3.0.0.dev45";
  pyproject = true;
  build-system = [ python3Packages.poetry-core ];

  src = fetchFromGitHub {
    owner = "gonsolo";
    repo = "librelane";
    rev = "gonsolo";
    hash = "sha256-sRZ5BSTAdNZpLxxOxdvM7Y1bS1VWjLVDJL9eyJU2+ns=";
    #hash = lib.fakeHash;
  };

  propagatedBuildInputs = with python3Packages; [
    pdk-ciel
    libparse-python
    numpy
    pandas
    click
    cloup
    deprecated
    httpx
    lxml
    psutil
    pyyaml
    rapidfuzz
    rich
    semver
    klayout
    yamlcore
  ];

  postInstall = ''
    site_packages=$out/${python3Packages.python.sitePackages}
    cp -r $src/librelane/scripts $site_packages/librelane/
    cp -r $src/librelane/examples $site_packages/librelane/
  '';
  # from above:
  #cp $src/librelane/pdk_hashes.yaml $site_packages/librelane/

  doCheck = false; # Set to true if you want to run the test suite during build

  meta = with lib; {
    description = "ASIC implementation flow infrastructure (Fork with Click fixes)";
    homepage = "https://github.com/gonsolo/librelane";
    license = licenses.asl20;
    maintainers = [ maintainers.gonsolo ];
    mainProgram = "librelane";
  };
}
