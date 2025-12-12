{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  gettext,
  python3,
}:

stdenvNoCC.mkDerivation {
  pname = "folder-color-switcher";
  version = "1.6.9";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "folder-color-switcher";
    # They don't really do tags, this is just a named commit.
    rev = "fefe156e336d2a0bbfe1ca61cf4e6873c74ae405";
    hash = "sha256-KL3ipzZiHEj+jwAmbIOCeSBOwm3bMpJf4PVhGS+Xx24=";
  };

  nativeBuildInputs = [
    gettext
    python3.pkgs.wrapPython
  ];

  postPatch = ''
    substituteInPlace usr/share/nemo-python/extensions/nemo-folder-color-switcher.py \
      --replace "/usr/share/locale" "$out/share/locale" \
      --replace "/usr/share/folder-color-switcher/colors.d" "/run/current-system/sw/share/folder-color-switcher/colors.d" \
      --replace "/usr/share/folder-color-switcher/color.svg" "$out/share/folder-color-switcher/color.svg"

    substituteInPlace usr/share/caja-python/extensions/caja-folder-color-switcher.py \
      --replace "/usr/share/folder-color-switcher/colors.d" "/run/current-system/sw/share/folder-color-switcher/colors.d"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv usr/share $out

    runHook postInstall
  '';

  # For Gdk.cairo_surface_create_from_pixbuf()
  # TypeError: Couldn't find foreign struct converter for 'cairo.Surface'
  passthru.nemoPythonExtensionDeps = [ python3.pkgs.pycairo ];

  meta = with lib; {
    homepage = "https://github.com/linuxmint/folder-color-switcher";
    description = "Change folder colors for Nemo and Caja";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
  };
}
