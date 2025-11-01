{
  lib,
  python3Packages,
  fetchFromGitHub,
  withOpencv ? false,
  withPyqt6 ? false,
  withQrcode ? true,
  script,
}:

python3Packages.buildPythonApplication rec {
  pname = "git-${script}";
  version = "5.5.2";

  src = fetchFromGitHub {
    owner = "AdityaGarg8";
    repo = "git-credential-email";
    tag = "v${version}";
    hash = "sha256-N4w339MvIOronA4MKS4ipLpQt+0xo+JVbgKWFYP2zP0=";
  };

  dependencies =
    with python3Packages;
    [
      keyring
      requests
    ]
    ++ lib.optionals withPyqt6 [ pyqt6 ]
    ++ lib.optionals withQrcode [ qrcode ]
    ++ lib.optionals (script == "protonmail") [
      bcrypt
      cryptography
      pgpy
      requests-toolbelt
      typing-extensions
    ]
    ++ lib.optionals (script == "protonmail" && withOpencv) [ opencv4 ];

  pyproject = false;

  installPhase = ''
    install -D -t $out/bin git-${script}
  '';

  meta = rec {
    description = "Git credential helpers for Microsoft Outlook, Gmail, Yahoo, AOL and Proton Mail accounts";
    homepage = "https://github.com/AdityaGarg8/git-credential-email";
    changelog = "${homepage}/releases/tag/${src.tag}";
    license = with lib.licenses; [
      asl20
      gpl3Only
    ];
    maintainers = with lib.maintainers; [ sephalon ];
  };
}
