{
  lib,
  installShellFiles,
  python3,
  fetchFromGitHub,
  fetchPypi,
  nix-update-script,
  testers,
  gimme-aws-creds,
}:

let
  python =
    let
      packageOverrides = _: super: {
        # okta>=3.0.0 breaks gimme-aws-creds, need to pin to 2.9.latest
        okta = super.okta.overridePythonAttrs (_: rec {
          version = "2.9.13";
          src = fetchPypi {
            pname = "okta";
            inherit version;
            hash = "sha256-jY6SZ1G3+NquF5TfLsGw6T9WO4smeBYT0gXLnRDoN+8=";
          };
        });
      };
    in
    python3.override {
      inherit packageOverrides;
      self = python;
    };
in
python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "gimme-aws-creds";
  version = "2.8.2"; # N.B: if you change this, check if overrides are still up-to-date
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Nike-Inc";
    repo = "gimme-aws-creds";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fsFYcfbLeYV6tpOGgNrFmYjcUAmdsx5zwUbvcctwFVs=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  pythonRemoveDeps = [
    "configparser"
  ];

  dependencies = with python.pkgs; [
    boto3
    beautifulsoup4
    ctap-keyring-device
    requests
    okta
    pyjwt
    html5lib
    furl
  ];

  preCheck = ''
    # Disable using platform's keyring unavailable in sandbox
    export PYTHON_KEYRING_BACKEND="keyring.backends.fail.Keyring"
  '';

  nativeCheckInputs = with python.pkgs; [
    pytestCheckHook
    responses
  ];

  disabledTests = [
    "test_build_factor_name_webauthn_registered"
  ];

  pythonImportsCheck = [
    "gimme_aws_creds"
  ];

  postInstall = ''
    rm $out/bin/gimme-aws-creds.cmd
    chmod +x $out/bin/gimme-aws-creds
    installShellCompletion --bash --name gimme-aws-creds $out/bin/gimme-aws-creds-autocomplete.sh
    rm $out/bin/gimme-aws-creds-autocomplete.sh
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = gimme-aws-creds;
      command = ''touch tmp.conf && OKTA_CONFIG="tmp.conf" gimme-aws-creds --version'';
      version = "gimme-aws-creds ${finalAttrs.version}";
    };
  };

  meta = {
    homepage = "https://github.com/Nike-Inc/gimme-aws-creds";
    changelog = "https://github.com/Nike-Inc/gimme-aws-creds/releases";
    description = "CLI that utilizes Okta IdP via SAML to acquire temporary AWS credentials";
    mainProgram = "gimme-aws-creds";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jbgosselin ];
  };
})
