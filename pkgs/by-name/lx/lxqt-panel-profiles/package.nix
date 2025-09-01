{
  lib,
  stdenv,
  fetchFromGitea,
  python3Packages,
  qt6,
  bash,
}:
let
  pythonWithPyqt6 = python3Packages.python.withPackages (ps: [
    ps.pyqt6
  ]);
in
stdenv.mkDerivation rec {
  pname = "lxqt-panel-profiles";
  version = "1.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "MrReplikant";
    repo = "lxqt-panel-profiles";
    rev = "v${version}";
    hash = "sha256-mI/Rg3YeK64R3cCn+xz4+CHZldGteZ4Id4h/YUcreW4=";
  };

  postPatch = ''
    # after copying the layouts folder from the nix store
    # add write permissions to the folder, so saving profiles works
    substituteInPlace usr/bin/lxqt-panel-profiles \
    --replace-fail 'cp -r /usr/share/lxqt-panel-profiles/layouts $XDG_DATA_HOME/lxqt-panel-profiles' 'cp -r /usr/share/lxqt-panel-profiles/layouts $XDG_DATA_HOME/lxqt-panel-profiles; chmod -R u+w,g+w $XDG_DATA_HOME/lxqt-panel-profiles;'

    substituteInPlace usr/bin/lxqt-panel-profiles \
    --replace-fail "/bin/bash" "${bash}/bin/bash" \
    --replace-fail "/usr/lib/" "$out/lib/" \
    --replace-fail "python3" "${pythonWithPyqt6}/bin/python"

    substituteInPlace usr/lib/lxqt-panel-profiles/lxqt-panel-profiles.py \
    --replace-fail "qdbus6" "${qt6.qttools}/bin/qdbus"
  '';

  installPhase = ''
    mkdir $out
    mv usr/* $out
  '';

  meta = {
    description = "";
    homepage = "https://codeberg.org/MrReplikant/lxqt-panel-profiles/";
    changelog = "https://codeberg.org/MrReplikant/lxqt-panel-profiles/releases/tag/${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ linuxissuper ];
    mainProgram = "lxqt-panel-profiles";
    platforms = lib.platforms.linux;
  };
}
