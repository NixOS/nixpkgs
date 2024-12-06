{ stdenvNoCC
, lib
, fetchFromGitHub
, gettext
, python3
}:

stdenvNoCC.mkDerivation rec {
  pname = "folder-color-switcher";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    # They don't really do tags, this is just a named commit.
    rev = "ba8ea15a48a1a31f318676f4079789af20bdf099";
    hash = "sha256-jbfc831wTA3NMa905ZzMnV0dyzzqZxOzrRPdgS7E2ZU=";
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
    maintainers = teams.cinnamon.members;
  };
}
