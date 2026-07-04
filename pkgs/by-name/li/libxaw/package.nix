{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxext,
  libxmu,
  libxpm,
  libxt,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxaw";
  version = "1.0.16";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXaw-${finalAttrs.version}.tar.xz";
    hash = "sha256-cx1XK1THCPgeGXpq+oAWkY4uBt/TAl4GbKZCpbjDnI8=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxext
    libxmu
    libxpm
    libxt
  ];

  propagatedBuildInputs = [
    xorgproto
    libxt
    # needs to be propagated because of header file dependencies
    libxmu
  ];

  postInstall =
    # remove dangling symlinks to .so files on static
    lib.optionalString stdenv.hostPlatform.isStatic "rm $out/lib/*.so*";

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXaw \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "X Athena Widget Set, based on the X Toolkit Intrinsics (Xt) Library";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxaw";
    license = with lib.licenses; [
      mitOpenGroup
      x11
      hpndSellVariant
      hpnd
    ];
    maintainers = [ ];
    pkgConfigModules = [
      "xaw6"
      "xaw7"
    ];
    platforms = lib.platforms.unix;
  };
})
