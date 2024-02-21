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
  version = "0-unstable-2024-02-02";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Bavarder";
    repo = "Bavarder";
    rev = "0df6f823b62e296163f757ecf825b5c129bde3ce";
    hash = "sha256-udE56nC1psBUMYgodCpFk6KRMvQIZ3uCG8bukzMwaWE=";
  };

  patches = [
    # Removes gpt4all support. It would be lots of work to package it properly
    # and we already have ollama with working ROCm + CUDA in nixpkgs.
    ./0001-remove-gpt4all-support.patch

    # Instead of packaging older openai I've made Bavarder work with what we
    # have in nixpkgs with some help of
    # https://github.com/openai/openai-python/discussions/742
    ./0002-fix-for-newer-openai.patch

    # Bavarder imports XdpGtk4 but doesn't use it. Remove the import so we don't
    # have to pull in libportal-gtk4
    ./0003-remove-XdpGtk4.patch
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
