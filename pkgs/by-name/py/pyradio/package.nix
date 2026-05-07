{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pyradio";
  version = "0.9.3.11.30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coderholic";
    repo = "pyradio";
    tag = finalAttrs.version;
    hash = "sha256-b4Euo9rD/A7PjROOaigx2ITel1uA7fa6S6bNi76FeUw=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    dnspython
    netifaces
    psutil
    python-dateutil
    requests
    rich
  ];

  postPatch = ''
    # Disable update check
    substituteInPlace pyradio/config \
      --replace-fail "distro = None" "distro = NixOS"
  '';

  checkPhase = ''
    $out/bin/pyradio --help
  '';

  postInstall = ''
    installManPage *.1

    install -Dm644 $src/devel/pyradio.desktop \
      "$out/share/applications/pyradio.desktop"

    install -Dm644 "$src/pyradio/icons/pyradio.png" \
      "$out/share/icons/hicolor/512x512/apps/pyradio.png"
  '';

  meta = {
    homepage = "http://www.coderholic.com/pyradio/";
    description = "Curses based internet radio player";
    mainProgram = "pyradio";
    changelog = "https://github.com/coderholic/pyradio/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      contrun
      magicquark
      yayayayaka
    ];
  };
})
