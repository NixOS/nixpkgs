{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  pkg-config,
  xorgproto,
  libpthread-stubs,
  libxcb,
  xtrans,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libx11";
  version = "1.8.12";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libX11-${finalAttrs.version}.tar.xz";
    hash = "sha256-+gJvm7AST01sgI+a70BXqtZeezXY/0OVHO8Kvga7mpo=";
  };

  strictDeps = true;

  CPP = lib.optionalString stdenv.hostPlatform.isDarwin "clang -E -";

  preConfigure = ''
    sed 's/^as_dummy.*/as_dummy="\$PATH"/' -i configure
  '';
  configureFlags =
    lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "--enable-malloc0returnsnull"
    ++ lib.optional (stdenv.targetPlatform.useLLVM or false) "ac_cv_path_RAWCPP=cpp";

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ] ++ lib.optional stdenv.hostPlatform.isStatic (buildPackages.stdenv.cc.libc.static or null);

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libpthread-stubs
    libxcb
    xtrans
  ];
  propagatedBuildInputs = [ xorgproto ];

  postInstall = ''
    # Remove useless DocBook XML files.
    rm -rf $out/share/doc
  '';

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libX11 \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Core X11 protocol client library (aka \"Xlib\")";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libx11";
    license = with lib.licenses; [
      mit
      mitOpenGroup
      x11
      hpndDoc
      hpndSellVariant
      hpndDocSell
      hpnd
      bsd1
      isc
      # multiple:
      # - custom mit-like license by Tektronix specific to their TekHVC Color Space thingy
      #
      free
      # The "source code modified by FUJITSU LIMITED under the Joint Development Agreement for the
      # CDE/Motif PST" is possibly unfree.
      # upstream issue: https://gitlab.freedesktop.org/xorg/lib/libx11/-/issues/217
      # unfree
    ];
    maintainers = [ ];
    pkgConfigModules = [
      "x11"
      "x11-xcb"
    ];
    platforms = lib.platforms.unix;
  };
})
