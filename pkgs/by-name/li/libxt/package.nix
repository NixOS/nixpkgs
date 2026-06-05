{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  pkg-config,
  xorgproto,
  libx11,
  libsm,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxt";
  version = "1.3.1";

  outputDoc = "devdoc";
  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXt-${finalAttrs.version}.tar.xz";
    hash = "sha256-4Kd0szMk9NTAWxmepFBQ+HIGWG2BZV+L7026Q02TEog=";
  };

  strictDeps = true;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libsm
  ];

  propagatedBuildInputs = [
    xorgproto
    libx11
    # needs to be propagated because of header file dependencies
    libsm
  ];

  configureFlags =
    lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "--enable-malloc0returnsnull"
    ++ lib.optional (stdenv.targetPlatform.useLLVM or false) "ac_cv_path_RAWCPP=cpp";

  env = {
    CPP = if stdenv.hostPlatform.isDarwin then "clang -E -" else "${stdenv.cc.targetPrefix}cc -E -";
  };

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXt \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "X Toolkit Intrinsics library";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxt";
    license = with lib.licenses; [
      mit
      hpndSellVariant
      hpnd
      mitOpenGroup
      x11
    ];
    maintainers = [ ];
    pkgConfigModules = [ "xt" ];
    platforms = lib.platforms.unix;
  };
})
