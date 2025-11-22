{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxkbfile,
  libx11,
  libxext,
  libxmu,
  libxt,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "oclock";
  version = "1.0.6";

  src = fetchurl {
    url = "mirror://xorg/individual/app/oclock-${finalAttrs.version}.tar.xz";
    hash = "sha256-PuheXi0hHsp724sv4OO68xmYgpr0gZi1+pu+4qoNJL4=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxkbfile
    libx11
    libxext
    libxmu
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
    description = "simple analog clock using the X11 SHAPE extension to make a round window";
    homepage = "https://gitlab.freedesktop.org/xorg/app/oclock";
    license = with lib.licenses; [
      mitOpenGroup
      x11
    ];
    mainProgram = "oclock";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
