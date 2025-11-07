{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libX11,
  libXext,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxv";
  version = "1.0.13";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXv-${finalAttrs.version}.tar.xz";
    hash = "sha256-fTSRCVjhwfjRk9go/qG32hkilygKNUN68GkvADugN1U=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libX11
    libXext
  ];

  configureFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXv \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Xlib-based library for the X Video (Xv) extension to the X Window System";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxv";
    license = with lib.licenses; [
      hpnd
      hpndSellVariant
    ];
    maintainers = [ ];
    pkgConfigModules = [ "xv" ];
    platforms = lib.platforms.unix;
  };
})
