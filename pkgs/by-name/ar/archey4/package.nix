{
  fetchFromGitHub,
  installShellFiles,
  lib,
  pciutils,
  procps,
  python3Packages,
  stdenv,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "archey4";
  version = "4.15.0.0";
  __structuredAttrs = true;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HorlogeSkynet";
    repo = "archey4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R3Pb5gS/xpQdR1OjQKIL83w+BCvvp0In2roJVCN769E=";
  };

  patches = [ ./fix-subprocess-path.patch ];

  # Fill in the man page placeholders like upstream's packaging/build.sh, using
  # the release date from the changelog to stay reproducible.
  postPatch = ''
    releaseDate=$(sed -n 's/^## \[v${finalAttrs.version}\] - //p' CHANGELOG.md)
    releaseMonth=$(date --utc --date="''${releaseDate:?}" '+%B %Y')
    substituteInPlace archey.1 \
      --replace-fail '"''${DATE}"' "\"$releaseMonth\"" \
      --replace-fail '"archey4 ''${VERSION}"' '"archey4 ${finalAttrs.version}"'
  '';

  build-system = with python3Packages; [ setuptools ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies = with python3Packages; [
    distro
    netifaces
  ];

  # Fallback `ps` and `lspci` for process and GPU detection
  makeWrapperArgs = lib.optionals stdenv.hostPlatform.isLinux [
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath [
      pciutils
      procps
    ])
  ];

  postInstall = ''
    installManPage archey.1
  '';

  nativeCheckInputs = with python3Packages; [ unittestCheckHook ];

  pythonImportsCheck = [ "archey" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Maintained fork of the original Archey (Linux) system tool";
    homepage = "https://github.com/HorlogeSkynet/archey4";
    changelog = "https://github.com/HorlogeSkynet/archey4/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "archey";
  };
})
