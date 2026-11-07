{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  gobject-introspection,
  wrapGAppsHook4,
  gst_all_1,
  libadwaita,
  pipewire,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "lumux";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "enginkirmaci";
    repo = "lumux";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-LBRuYdKe8Jqewac1KRbKBSr1KVoFQEvKnJ3YRVyTZ1E=";
  };

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    pipewire # pipewiresrc
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    zeroconf
    urllib3
    numpy
    pillow
    requests
    pydbus
  ];

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Philips Hue Sync for Linux on Wayland";
    homepage = "https://github.com/enginkirmaci/lumux";
    mainProgram = "lumux";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    longDescription = "Real-time ambient lighting synchronization for Philips Hue lights on Linux (Wayland) using a GTK4/Adwaita interface";
    maintainers = with lib.maintainers; [ olillin ];
  };
})
