{
  lib,
  python3Packages,
  fetchFromGitHub,
  pkgs,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
  dejavu_fonts,
  fetchpatch,
}:
python3Packages.buildPythonApplication rec {
  pname = "qr-backup";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "za3k";
    repo = "qr-backup";
    tag = "v${version}";
    hash = "sha256-Sre8cHbrRqJTX6+3HiLj6Ky8Bw+hg6UXItwRUtLzHZA=";
  };

  pyproject = false;

  nativeBuildInputs = [
    installShellFiles
  ];

  dependencies = with pkgs; [
    python3Packages.pillow
    python3Packages.qrcode
    python3Packages.reedsolo
    which
    zbar
    imagemagickBig
    gnupg
  ];

  patches = [
    # Backported from the upstream master branch so we can `doCheck` on
    # the latest release version without needing to vendor a patch to
    # disable the fragile regression tests
    (fetchpatch {
      name = "0001-Rename-from-regression-to-reproducibility-tests.patch";
      url = "https://github.com/za3k/qr-backup/commit/ec8ab373110de62d2e1f6f47c9a34e9e1a73c571.patch";
      hash = "sha256-93wxmCeH3qxZkDLZa9giMGUmVHdXSitXzet6WnAbQRw=";
    })
    (fetchpatch {
      name = "0002-Add-fast-option-to-tests.patch";
      url = "https://github.com/za3k/qr-backup/commit/e7d028eb4fddaa7f8628c88e1604d5e64f546389.patch";
      hash = "sha256-5Ib+bs+ciqH1z0kvHBD7PrefTTwD6nWk+6pEPqxc9uU=";
    })
  ];

  postPatch = ''
    substituteInPlace qr-backup \
      --replace-fail '"DejaVuSansMono.ttf"' "'${dejavu_fonts}/share/fonts/truetype/DejaVuSansMono.ttf'" \
      --replace-fail '"python3", sys.argv[0]' "'$out/bin/qr-backup'"
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 755 qr-backup "$out/bin/qr-backup"
    mv docs/qr-backup.1{.man,} # remove .man suffix
    installManPage docs/qr-backup.1

    runHook postInstall
  '';

  doCheck = true;
  doInstallCheck = true;
  nativeCheckInputs = with pkgs; [
    versionCheckHook
    which
    zbar
  ];
  installCheckPhase = ''
    runHook preInstallCheck

    substituteInPlace tests/test.py \
      --replace-fail '"python3", "qr-backup"' "'$out/bin/qr-backup'"
    export GNUPGHOME="$(mktemp -d)"
    make test-fast

    runHook postInstallCheck
  '';
  versionCheckProgramArg = [ "--version" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Utility to generate paper backup of files using QR codes";
    homepage = "https://github.com/za3k/qr-backup";
    changelog = "https://github.com/za3k/qr-backup/blob/v${version}/docs/CHANGELOG";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [
      acuteaangle
    ];
    mainProgram = "qr-backup";
  };
}
