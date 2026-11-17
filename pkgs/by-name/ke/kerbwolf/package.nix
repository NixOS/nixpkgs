{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "kerbwolf";
  version = "0.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "StrongWind1";
    repo = "KerbWolf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZeczB/LgPe/F9MXfuF9bVYB0odnSRzV3FEkXNtN0BUM=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    dnspython
    gssapi
    impacket
    pyasn1
    pycryptodomex
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pythonImportsCheck = [ "kerbwolf" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kerberos roasting and TGT attack toolkit for Active Directory";
    homepage = "https://github.com/StrongWind1/KerbWolf";
    changelog = "https://github.com/StrongWind1/KerbWolf/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
