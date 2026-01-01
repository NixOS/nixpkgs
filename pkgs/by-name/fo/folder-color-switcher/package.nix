{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  gettext,
  python3,
}:

stdenvNoCC.mkDerivation {
  pname = "folder-color-switcher";
<<<<<<< HEAD
  version = "1.7.0";
=======
  version = "1.6.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "folder-color-switcher";
    # They don't really do tags, this is just a named commit.
<<<<<<< HEAD
    rev = "c528788f05697d1e176df4f869d64bcebbab1528";
    hash = "sha256-RSIiNjoU2Qk+0ACirUeo+VSfpjQ8NNJqmKKASD7RZXs=";
=======
    rev = "d135f29d688d89a0e7b48acec9e08738c7976ee1";
    hash = "sha256-3EFnQxTYcJLGjfAzZNS7pgVDUwuU3juOAwUyaKOHemI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/linuxmint/folder-color-switcher";
    description = "Change folder colors for Nemo and Caja";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
=======
  meta = with lib; {
    homepage = "https://github.com/linuxmint/folder-color-switcher";
    description = "Change folder colors for Nemo and Caja";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
