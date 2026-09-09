{
  lib,
  stdenv,
  fetchurl,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-ibm-type1";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-ibm-type1-${finalAttrs.version}.tar.xz";
    hash = "sha256-xDlelbpG1AxK0XN+kcrCDAq3VBEym2DbXZn+2Stgzn8=";
  };

  strictDeps = true;

  nativeBuildInputs = [ mkfontscale ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/font/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "IBM Courier Type1 fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/ibm-type1";
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
