{
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  gobject-introspection,
  lib,
  libadwaita,
  meson,
  ninja,
  python3Packages,
  stdenv,
  wrapGAppsHook4,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cartridges";
  version = "2.8.4";

  src = fetchFromGitHub {
    owner = "kra-mo";
    repo = "cartridges";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x6utIvU4LxM/CJogy5JrFrDTLFmXbgItgqtT+lM7FGA=";
  };

  pythonPath = with python3Packages; [
    pillow
    pygobject3
    pyyaml
    requests
  ];

  # TODO: remove this when #286814 hits master
  mesonFlags = [ "-Dtiff_compression=jpeg" ];

  buildInputs = [
    libadwaita
    (python3Packages.python.withPackages (_: finalAttrs.pythonPath))
  ];

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    python3Packages.wrapPython
    wrapGAppsHook4
  ];

  dontWrapGApps = true;

  postFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    wrapPythonPrograms "$out/bin" "$out" "$pythonPath"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A GTK4 + Libadwaita game launcher";
    mainProgram = "cartridges";
    longDescription = ''
      A simple game launcher for all of your games.
      It has support for importing games from Steam, Lutris, Heroic
      and more with no login necessary.
      You can sort and hide games or download cover art from SteamGridDB.
    '';
    homepage = "https://apps.gnome.org/Cartridges/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.getchoo ];
    platforms = platforms.linux;
  };
})
