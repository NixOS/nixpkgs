{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxext,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxscrnsaver";
  version = "1.2.5";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXScrnSaver-${finalAttrs.version}.tar.xz";
    hash = "sha256-UFc2X4RyU+DidYcUQeEP94RsgyKl2I4eGH0ybeHNjQA=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxext
  ];

  propagatedBuildInputs = [ xorgproto ];

  configureFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXScrnSaver \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "X11 Screen Saver extension client library";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxscrnsaver";
    license = lib.licenses.x11;
    maintainers = [ ];
    pkgConfigModules = [ "xscrnsaver" ];
    platforms = lib.platforms.unix;
  };
})
