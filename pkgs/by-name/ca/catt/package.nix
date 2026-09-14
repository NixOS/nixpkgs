{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
  versionCheckHook,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "catt";
  version = "0.13.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "skorokithakis";
    repo = "catt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VjwYfaBoQ7HMKG6BztAB3mmQps42MoHSAiC2jHbRS/Q=";
  };

  build-system = [
    python3Packages.poetry-core
  ];

  dependencies = [
    python3Packages.click
    python3Packages.ifaddr
    python3Packages.pychromecast
    python3Packages.requests
    python3Packages.yt-dlp
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  disabledTests = [
    # Require network access.
    "test_stream_info_youtube_video"
    "test_stream_info_youtube_playlist"
    "test_stream_info_other_video"
    "test_stream_info_direct_link"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  pythonImportsCheck = [
    "catt"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Allows you to send videos from many, many online sources to your Chromecast";
    homepage = "https://github.com/skorokithakis/catt";
    changelog = "https://github.com/skorokithakis/catt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.aaravrav ];
    mainProgram = "catt";
  };
})
