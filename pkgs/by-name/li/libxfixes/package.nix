{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libX11,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxfixes";
  version = "6.0.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXfixes-${finalAttrs.version}.tar.xz";
    hash = "sha256-tpX5PNJJlCGrAtInREWOZQzMiMHUyBMNYCACE6vALVg=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libX11
  ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXfixes \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Xlib-based library for the XFIXES Extension";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxfixes";
    license = with lib.licenses; [
      hpndSellVariant
      mit
    ];
    maintainers = [ ];
    pkgConfigModules = [ "xfixes" ];
    platforms = lib.platforms.unix;
  };
})
