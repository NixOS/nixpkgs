{ lib
, fetchFromGitHub
, fetchPypi
, python3
, installShellFiles
}:

let
  py = python3.override {
    self = py;
    packageOverrides = self: super: {

      click = super.click.overridePythonAttrs (oldAttrs: rec {
        version = "7.1.2";

        src = fetchPypi {
          pname = "click";
          inherit version;
          hash = "sha256-0rUlXHxjSbwb0eWeCM0SrLvWPOZJ8liHVXg6qU37axo=";
        };
        disabledTests = [ "test_bytes_args" ]; # https://github.com/pallets/click/commit/6e05e1fa1c2804
      });

      jmespath = super.jmespath.overridePythonAttrs (oldAttrs: rec {
        version = "0.10.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9";
          hash = "";
        };
        doCheck = false;
      });

    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "oci-cli";
  version = "3.14.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yooEZuSIw2EMJVyT/Z/x4hJi8a1F674CtsMMGkMAYLg=";
  };

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = [
    arrow
    certifi
    click
    cryptography
    jmespath
    oci
    prompt-toolkit
    pyopenssl
    python-dateutil
    pytz
    pyyaml
    retrying
    six
    terminaltables
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "cryptography>=3.2.1,<=37.0.2" "cryptography" \
      --replace "pyOpenSSL>=17.5.0,<=22.0.0" "pyOpenSSL" \
      --replace "PyYAML>=5.4,<6" "PyYAML" \
      --replace "prompt-toolkit==3.0.29" "prompt-toolkit" \
      --replace "terminaltables==3.1.0" "terminaltables" \
      --replace "oci==2.78.0" "oci"
  '';

  postInstall = ''
    cat >oci.zsh <<EOF
    #compdef oci
    zmodload -i zsh/parameter
    autoload -U +X bashcompinit && bashcompinit
    if ! (( $+functions[compdef] )) ; then
        autoload -U +X compinit && compinit
    fi

    EOF
    cat src/oci_cli/bin/oci_autocomplete.sh >>oci.zsh

    installShellCompletion \
      --cmd oci \
      --bash src/oci_cli/bin/oci_autocomplete.sh \
      --zsh oci.zsh
  '';

  # https://github.com/oracle/oci-cli/issues/187
  doCheck = false;

  pythonImportsCheck = [
    " oci_cli "
  ];

  meta = with lib; {
    description = "Command Line Interface for Oracle Cloud Infrastructure";
    homepage = "https://docs.cloud.oracle.com/iaas/Content/API/Concepts/cliconcepts.htm";
    license = with licenses; [ asl20 /* or */ upl ];
    maintainers = with maintainers; [ ilian ];
  };
}
