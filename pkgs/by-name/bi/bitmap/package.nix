{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libx11,
  libxaw,
  xbitmaps,
  libxmu,
  xorgproto,
  libxt,
  wrapWithXFileSearchPathHook,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bitmap";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://xorg/individual/app/bitmap-${finalAttrs.version}.tar.xz";
    hash = "sha256-Y9Qutj/kgZizk0SvSZSeXkJMxizo1yJ4H9rUpPo0JuY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wrapWithXFileSearchPathHook
  ];

  buildInputs = [
    libx11
    libxaw
    xbitmaps
    libxmu
    xorgproto
    libxt
  ];

  installFlags = [ "appdefaultdir=$(out)/share/X11/app-defaults" ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/app/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "X bitmap (XBM) editor and converter utilities";
    homepage = "https://gitlab.freedesktop.org/xorg/app/bitmap";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "bitmap";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
