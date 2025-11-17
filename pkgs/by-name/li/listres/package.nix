{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxaw,
  libxmu,
  xorgproto,
  libxt,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "listres";
  version = "1.0.6";

  src = fetchurl {
    url = "mirror://xorg/individual/app/listres-${finalAttrs.version}.tar.xz";
    hash = "sha256-TRxT79abplTyh34Vd+mUx4h0sFEvobBmbP/PRSruQ8o=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxaw
    libxmu
    xorgproto
    libxt
  ];

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
    description = "Utility to list X resources for a widget written using a toolkit based on libXt";
    homepage = "https://gitlab.freedesktop.org/xorg/app/listres";
    license = lib.licenses.x11;
    mainProgram = "listres";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
