{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  gnome-icon-theme,
  mint-x-icons,
  hicolor-icon-theme,
}:

stdenvNoCC.mkDerivation rec {
  pname = "iconpack-obsidian";
  version = "4.15";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = "iconpack-obsidian";
    rev = "v${version}";
    sha256 = "1f32isq1xyn9b6p1nx5rssqgg9gw0jp9ld19860xk29fspmlfb8n";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    gnome-icon-theme
    mint-x-icons
    hicolor-icon-theme
  ];
  # still missing parent themes: Ambient-MATE, Faenza-Dark, KFaenza

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    mv Obsidian* $out/share/icons

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    # Fix broken symlink only if needed
    # https://github.com/NixOS/nixpkgs/issues/394218

    broken_symlink="$out/share/icons/Obsidian/actions/96/lock.svg"
    target_svg="$out/share/icons/Obsidian/actions/scalable/system-lock-screen.svg"

    if [ -h "$broken_symlink" ] && [ ! -e "$broken_symlink" ]; then
      echo "=== Fixing broken symlink: $broken_symlink"
      rm -f "$broken_symlink"
      ln -s "$target_svg" "$broken_symlink"
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "Gnome icon pack based upon Faenza";
    homepage = "https://github.com/madmaxms/iconpack-obsidian";
    license = licenses.gpl3Only;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
