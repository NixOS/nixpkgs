{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "credspy";
  version = "1.0.0-unstable-2026-06-22";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "RedByte1337";
    repo = "CredSpy";
    # https://github.com/RedByte1337/CredSpy/issues/2
    rev = "0fa54595fd6e5d1f903d8d248a7e9f3203e7ec09";
    hash = "sha256-PHSLke90obZw2cwY7zqp1DNnG26Hf+ixHunMwQHoU3o=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [ requests ];

  pythonImportsCheck = [ "credspy" ];

  # Project has no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Entra ID user enumeration and auth method discovery";
    homepage = "https://github.com/RedByte1337/CredSpy";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "credspy";
  };
})
