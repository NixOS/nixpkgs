{
  lib,
  stdenv,
  fetchFromGitea,
  python3Packages,
  qt6,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-panel-profiles";
  version = "1.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "MrReplikant";
    repo = "lxqt-panel-profiles";
    rev = version;
    hash = "sha256-YGjgTLodVTtDzP/SOEg+Ehf1LYggTnG1H1rN5m1jaNM=";
  };

  installPhase = ''
    mkdir $out
    mv usr $out/usr
  '';

  mypython = python3Packages.python.withPackages (ps: [
    ps.pyqt6
  ]);

  postPatch = ''
    substituteInPlace usr/bin/lxqt-panel-profiles \
    --replace-fail "/bin/bash" "${bash}/bin/bash" \
    --replace-fail 'cp -r /usr/share/lxqt-panel-profiles/layouts $XDG_DATA_HOME/lxqt-panel-profiles' 'cp -r /usr/share/lxqt-panel-profiles/layouts $XDG_DATA_HOME/lxqt-panel-profiles; chmod -R u+w,g+w $XDG_DATA_HOME/lxqt-panel-profiles;' \
    --replace-fail "/usr/share/" "$out/usr/share/" \
    --replace-fail "python3" "${mypython}/bin/python"

    substituteInPlace usr/share/lxqt-panel-profiles/lxqt-panel-profiles.py \
    --replace-fail "qdbus" "${qt6.qttools}/bin/qdbus"
  '';

  meta = {
    description = "";
    homepage = "https://codeberg.org/MrReplikant/lxqt-panel-profiles/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ linuxissuper ];
    mainProgram = "lxqt-panel-profiles";
    platforms = lib.platforms.linux;
  };
}
