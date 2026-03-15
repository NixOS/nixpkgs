{
  lib,
  python3Packages,
  fetchFromGitHub,
  withOpencv ? false,
  withPyqt6 ? builtins.elem "git-protonmail" scripts,
  withQrcode ? true,
  pname ? "git-credential-email",
  scripts ? [
    "git-credential-aol"
    "git-credential-gmail"
    "git-credential-outlook"
    "git-credential-yahoo"
    "git-msgraph"
    "git-protonmail"
  ],
  description ? "Git credential helpers for Microsoft Outlook, Gmail, Yahoo, AOL and Proton Mail accounts",
  license ? with lib.licenses; [
    asl20
    gpl3Only
  ],
}:

let
  withProtonmail = builtins.elem "git-protonmail" scripts;
in
python3Packages.buildPythonApplication (finalAttrs: {
  inherit pname;
  version = "5.7.1";

  src = fetchFromGitHub {
    owner = "AdityaGarg8";
    repo = "git-credential-email";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u5I88zHr4bACndc0hZF953DxyjfhOlRiXD49DO9On1k=";
  };

  dependencies =
    with python3Packages;
    [
      keyring
      requests
    ]
    ++ lib.optionals withPyqt6 [ pyqt6 ]
    ++ lib.optionals withQrcode [ qrcode ]
    ++ lib.optionals withProtonmail [
      bcrypt
      cryptography
      pgpy
      requests-toolbelt
      typing-extensions
    ]
    ++ lib.optionals (withProtonmail && withOpencv) [ opencv4 ];

  pyproject = false;

  installPhase = ''
    install -D -t $out/bin ${lib.concatStringsSep " " scripts}
  '';

  meta = {
    inherit description license;
    homepage = "https://github.com/AdityaGarg8/git-credential-email";
    changelog = "https://github.com/AdityaGarg8/git-credential-email/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ sephalon ];
  };
})
