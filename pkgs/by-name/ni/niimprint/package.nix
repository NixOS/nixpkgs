{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "niimprint";
  version = "0.1.0"; # Keep in sync with pyproject.toml

  src = fetchFromGitHub {
    owner = "AndBondStyle";
    repo = "niimprint";
    rev = "be39f68c16a5a7dc1b09bb173700d0ee1ec9cb66"; # Or a specific commit hash
    sha256 = "sha256-+YISYchdqeVKrQ0h2cj5Jy2ezMjnQcWCCYm5f95H9dI="; # Needs to be updated
  };

  format = "pyproject";

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pillow
    pyserial
    click
  ];
  
  # Disable tests as the package doesn't have any
  doCheck = false;

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper ${python3.interpreter} $out/bin/niimprint \
      --prefix PYTHONPATH : ${python3.pkgs.makePythonPath propagatedBuildInputs}:$out/${python3.sitePackages} \
      --add-flags "-m niimprint"
  '';

  meta = with lib; {
    description = "A command line tool to print to Niimbot label printers";
    homepage = "https://github.com/AndBondStyle/niimprint";
    license = licenses.mit; # Repository appears to use MIT license
    maintainers = with maintainers; [ nicodemus26 ];
    platforms = platforms.all;
  };
}
