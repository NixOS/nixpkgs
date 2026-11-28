{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "localstack";
  version = "2026.8.2";
  format = "wheel";

  src = fetchPypi {
    pname = finalAttrs.pname;
    version = finalAttrs.version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    hash = "sha256-vqcC9dhVjK/J+7/72BoeUyCHJyDgjNa+Gk8dppSr3uc=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    asn1crypto
    boto3
    cachetools
    click
    cryptography
    dnslib
    dnspython
    docker
    plux
    psutil
    pyjwt
    pyotp
    python-dateutil
    python-dotenv
    pyyaml
    packaging
    requests
    rich
    semver
    tabulate
  ];

  nativeBuildInputs = [
    python3.pkgs.wheelUnpackHook
  ];

  pythonImportsCheck = [ "localstack_cli" ];

  # Test suite requires boto, which has been removed from nixpkgs
  # Just do minimal test, buildPythonPackage maps checkPhase
  # to installCheckPhase, so we can test that entrypoint point works.
  checkPhase = ''
    runHook preCheck

    export HOME=$(mktemp -d)
    $out/bin/localstack --version

    runHook postCheck
  '';

  # Propagating dependencies leaks them through $PYTHONPATH which causes issues
  # when used in nix-shell.
  postFixup = ''
    rm $out/nix-support/propagated-build-inputs
  '';

  meta = {
    description = "Fully functional local Cloud stack (legacy CLI)";
    homepage = "https://localstack.cloud/";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.purcell ];
    mainProgram = "localstack";
  };
})
