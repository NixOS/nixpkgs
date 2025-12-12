{
  lib,
  python3Packages,
  fetchPypi,
}:

let
  # onlykey requires a fork of libagent called lib-agent
  lib-agent = python3Packages.buildPythonPackage rec {
    pname = "lib-agent";
    version = "1.0.6";
    pyproject = true;

    src = fetchPypi {
      inherit version;
      pname = "lib-agent";
      hash = "sha256-IrJizIHDIPHo4tVduUat7u31zHo3Nt8gcMOyUUqkNu0=";
    };

    build-system = with python3Packages; [ setuptools ];

    dependencies = with python3Packages; [
      bech32
      cryptography
      pycryptodome
      docutils
      python-daemon
      backports-shutil-which
      configargparse
      python-daemon
      ecdsa
      pynacl
      mnemonic
      pymsgbox
      semver
      unidecode

      setuptools # pkg_resources is imported during runtime
    ];

    pythonImportsCheck = [ "libagent" ];

    meta = {
      description = "Using OnlyKey as hardware SSH and GPG agent";
      homepage = "https://github.com/trustcrypto/onlykey-agent/tree/ledger";
      license = lib.licenses.lgpl3Only;
      maintainers = with lib.maintainers; [ kalbasit ];
    };
  };
in
python3Packages.buildPythonApplication rec {
  pname = "onlykey-agent";
  version = "1.1.15";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SbGb7CjcD7cFPvASZtip56B4uxRiFKZBvbsf6sb8fds=";
  };

  postPatch = ''
    # we don't need this python script to be installed into $out/bin
    substituteInPlace setup.py \
      --replace-fail "scripts=['onlykey_agent.py']," ""
  '';

  build-system = [ python3Packages.setuptools ];

  dependencies = [ lib-agent ];

  pythonRemoveDeps = [ "onlykey" ]; # doesn't seem to be imported anywhere

  pythonImportsCheck = [ "onlykey_agent" ];

  meta = {
    description = "Middleware that lets you use OnlyKey as a hardware SSH/GPG device";
    homepage = "https://github.com/trustcrypto/onlykey-agent";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ kalbasit ];
  };
}
