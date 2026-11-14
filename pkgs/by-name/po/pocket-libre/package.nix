{
  lib,
  fetchFromGitHub,
  python3Packages,
  bluez,
  iw,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pocket-libre";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shahcolate";
    repo = "pocket-libre";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j/172DS91CxX4wnRwnim8VyDRfONg7R/EtSXw2kvpFc=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies =
    with python3Packages;
    [
      anthropic
      bleak
      click
      openai-whisper
      rich
      fastapi
    ]
    ++ python3Packages.fastapi.optional-dependencies.standard;

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [
      bluez
      iw
    ]}"
  ];

  meta = {
    description = "Replace vendor app for Pocket AI voice recorder over BLE/WiFi";
    homepage = "https://github.com/shahcolate/pocket-libre";
    changelog = "https://github.com/shahcolate/pocket-libre/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cimm ];
    mainProgram = "pocket-libre";
    platforms = lib.platforms.linux;
  };
})
