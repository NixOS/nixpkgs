{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "kerbwolf";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "StrongWind1";
    repo = "KerbWolf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m55Cm1McesFcjbkrzfJcYf/KEiwDArXUZR0FK2+s1x4=";
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
