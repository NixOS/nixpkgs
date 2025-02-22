{
  lib,
  fetchFromGitHub,
  fetchPypi,
  python3,
  installShellFiles,
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

py.pkgs.buildPythonApplication rec {
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

  propagatedBuildInputs = with py.pkgs; [
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

  pythonRelaxDeps = [
    "PyYAML"
    "cryptography"
    "oci"
    "prompt-toolkit"
    "pyOpenSSL"
    "terminaltables"
  ];

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

  doCheck = true;

  pythonImportsCheck = [
    " oci_cli "
  ];

  meta = with lib; {
    description = "Command Line Interface for Oracle Cloud Infrastructure";
    homepage = "https://docs.cloud.oracle.com/iaas/Content/API/Concepts/cliconcepts.htm";
    license = with licenses; [
      asl20 # or
      upl
    ];
    maintainers = with maintainers; [ ilian ];
  };
}
