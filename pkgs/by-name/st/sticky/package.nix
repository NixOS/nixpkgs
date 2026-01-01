{
  stdenv,
  lib,
  fetchFromGitHub,
  gobject-introspection,
  meson,
  ninja,
  python3,
  wrapGAppsHook3,
  xapp,
  glib,
  gspell,
  gtk3,
  xapp-symbolic-icons,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "sticky";
<<<<<<< HEAD
  version = "1.29";
=======
  version = "1.28";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "sticky";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-5KDjvohmdw8j5G8V+uFXPzRSRo/C2HgeRodWfguQjYg=";
=======
    hash = "sha256-6CRkeJ2xuUs3viyYxnrgGFUIakK7ANyVpPZuwU486NM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    sed -i -e "s|/usr/lib|$out/lib|" usr/bin/sticky
    sed -i -e "s|/usr/share|$out/share|" usr/lib/sticky/*.py
  '';

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    python3.pkgs.wrapPython
    wrapGAppsHook3
  ];

  buildInputs = [
    xapp
    glib
    gspell
    gtk3
    python3 # for patchShebangs
  ];

  pythonPath = with python3.pkgs; [
    pygobject3
    python-xapp
  ];

  preFixup = ''
    buildPythonPath "$out $pythonPath"

    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$program_PYTHONPATH"
      --prefix XDG_DATA_DIRS : "${lib.makeSearchPath "share" [ xapp-symbolic-icons ]}"
    )
  '';

  passthru = {
    updateScript = gitUpdater {
      ignoredVersions = ''master.*'';
    };
  };

<<<<<<< HEAD
  meta = {
    description = "Sticky notes app for the Linux desktop";
    mainProgram = "sticky";
    homepage = "https://github.com/linuxmint/sticky";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Sticky notes app for the Linux desktop";
    mainProgram = "sticky";
    homepage = "https://github.com/linuxmint/sticky";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      linsui
      bobby285271
    ];
  };
}
