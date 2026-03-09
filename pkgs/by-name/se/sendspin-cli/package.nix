{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  ...
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "sendspin-cli";
  version = "5.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sendspin";
    repo = "sendspin-cli";
    tag = finalAttrs.version;
    hash = "sha256-CTX2q85Ka5CV6YaKIA02Jiu5LKR7UsH7pxSnybos5k0=";
  };

  build-system = with python3Packages; [
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    aiosendspin
    aiosendspin-mpris
    numpy
    pychromecast
    pulsectl-asyncio
    qrcode
    readchar
    rich
    sounddevice
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Synchronized audio player for Sendspin servers";
    homepage = "https://github.com/Sendspin/sendspin-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fooker ];
    mainProgram = "sendspin-cli";
  };
})
