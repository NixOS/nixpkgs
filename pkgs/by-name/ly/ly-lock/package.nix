{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook4,
  gobject-introspection,
  gtk4,
  gtk4-layer-shell,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ly-lock";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rugbedbugg";
    repo = "ly-lock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GQS5POZzOM8u+3uRNWHsIvKpS32TxCpo4/Vw9SAaPdQ=";
  };

  build-system = [ python3Packages.setuptools ];

  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    gtk4-layer-shell
  ];

  dependencies = with python3Packages; [
    numpy
    pygobject3
    pyopengl
    python-pam
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --set LY_LOCK_LAYER_SHELL ${gtk4-layer-shell}/lib/libgtk4-layer-shell.so.0
    )
  '';

  pythonImportsCheck = [ "ly_lock" ];

  meta = {
    description = "Wayland lock screen that looks and behaves like the ly display manager";
    homepage = "https://github.com/rugbedbugg/ly-lock";
    changelog = "https://github.com/rugbedbugg/ly-lock/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ rugbedbugg ];
    mainProgram = "ly-lock";
    platforms = lib.platforms.linux;
  };
})
