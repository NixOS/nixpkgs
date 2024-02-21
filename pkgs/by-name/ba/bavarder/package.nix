{ appstream-glib
, blueprint-compiler
, desktop-file-utils
, fetchFromGitHub
, gettext
, gtk4
, gtksourceview5
, lib
, libadwaita
, libportal
, meson
, ninja
, pkg-config
, python3Packages
, wrapGAppsHook4
}:

python3Packages.buildPythonApplication rec {
  pname = "bavarder";
  version = "1.0.0-unstable-2024-03-23";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Bavarder";
    repo = "Bavarder";
    rev = "bb6ca168f875e4f320fdd5d1eaf2d92d5a55bfa3";
    hash = "sha256-vwuynsTjTajPTLr4mxufGSyulwEjknhuJJsmPjNisTA=";
  };

  patches = [
    # Removes gpt4all support. It would be lots of work to package it properly
    # and we already have ollama with working ROCm + CUDA in nixpkgs.
    "${src}/0001-remove-gpt4all-support.patch"
  ];

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    gettext
    gtk4
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtksourceview5
    libadwaita
    libportal
  ];

  propagatedBuildInputs = with python3Packages; [
    babel
    gst-python
    lxml
    openai
    pillow
    pygobject3
    requests
  ];

  meta = with lib; {
    description = "Chit-chat with an AI";
    homepage = "https://github.com/Bavarder/Bavarder";
    license = with licenses; [ gpl3Only ];
    mainProgram = "bavarder";
    maintainers = with maintainers; [ surfaceflinger ];
    platforms = platforms.linux;
  };
}
