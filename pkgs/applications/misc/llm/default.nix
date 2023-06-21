{ lib, python3Packages, fetchPypi, fetchFromGitHub }:

let
  sutils = python3Packages.sqlite-utils.overrideAttrs (oldAttrs: rec {
    version = "3.35";
    pname = "sqlite-utils";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-j2/n+NEncs1c9FlHA6mNzQw3wP1oIN0gVBunS5/KNjo=";
    };
  });

  ulid = import ./ulid.nix { inherit lib python3Packages fetchPypi; };
in python3Packages.buildPythonApplication rec {
  pname = "llm";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-jdE2P8GyvGL2u3IqdcLC5E1KgxuqTl1Zh2Mu9VCbHU0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "click-default-group-wheel" "click-default-group"
  '';

  propagatedBuildInputs = [
    sutils
    ulid
    python3Packages.click-default-group
    python3Packages.openai
    python3Packages.pydantic
    python3Packages.pyyaml
    python3Packages.pluggy
  ];

  meta = with lib; {
    homepage = "https://github.com/simonw/llm";
    description = "Access large language models from the command-line";
    license = licenses.asl20;
    maintainers = with maintainers; [ asimpson ];
  };
}
