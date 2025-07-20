{
  stdenv,
  lib,
  qt6,
  fetchFromGitHub,
  p7zip,
  versionCheckHook,
  nix-update-script,
  python3,
  archiveSupport ? true,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "kcc";
  version = "7.5.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ciromattia";
    repo = "kcc";
    tag = "v${version}";
    hash = "sha256-XB+xss/QiZuo6gWphyjFh9DO74O5tNqfX5LUzsa4gqo=";
  };

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  buildInputs = [ qt6.qtbase ] ++ lib.optionals stdenv.hostPlatform.isLinux [ qt6.qtwayland ];
  propagatedBuildInputs = with python3.pkgs; [
    packaging
    pillow
    psutil
    python-slugify
    raven
    requests
    natsort
    mozjpeg_lossless_optimization
    distro
    pyside6
    numpy
  ];

  qtWrapperArgs = lib.optionals archiveSupport [ ''--prefix PATH : ${lib.makeBinPath [ p7zip ]}'' ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/kcc-c2e";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Python app to convert comic/manga files or folders to EPUB, Panel View MOBI or E-Ink optimized CBZ";
    homepage = "https://kcc.iosphe.re";
    mainProgram = "kcc";
    changelog = "https://github.com/ciromattia/kcc/releases/tag/v${version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      dawidsowa
      adfaure
    ];
  };
}
