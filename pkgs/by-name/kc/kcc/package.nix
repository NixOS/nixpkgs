{
  stdenv,
  lib,
  qt6,
  python3Packages,
  fetchFromGitHub,
  p7zip,
  versionCheckHook,
  archiveSupport ? true,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "kcc";
  version = "7.3.3";

  src = fetchFromGitHub {
    owner = "ciromattia";
    repo = "kcc";
    rev = "refs/tags/v${version}";
    hash = "sha256-6zHUV4s1bOdARsTwNRxFM+s0p+6FLJhqJ9qG5BaBgas=";
  };

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ qt6.qtwayland ];
  propagatedBuildInputs = (
    with python3Packages;
    [
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
    ]
  );

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
