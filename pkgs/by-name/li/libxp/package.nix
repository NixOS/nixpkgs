# TODO: remove this deprecated package
# X.Org removed support for the Xprt server from the xorg-server releases in the 1.6.0 release in
# 2009, and the standalone git repo it was moved to has been unmaintained since 2009, making it
# difficult to actually use this library.
# Some packages in nixpkgs still somehow depend on it tho.
{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxau,
  libxext,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxp";
  version = "1.0.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXp-${finalAttrs.version}.tar.xz";
    hash = "sha256-HxnjuOgqNKj9mImn2a8KvoWIywP7V8N8VpY0zzud8aQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxau
    libxext
  ];

  propagatedBuildInputs = [ xorgproto ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXp \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "X Print Client Library";
    longDescription = ''
      This library provides support for X11 clients to print via the X Print Extension, as
      previously implemented in the Xprt server.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxp";
    license = lib.licenses.x11;
    maintainers = [ ];
    pkgConfigModules = [ "xp" ];
    platforms = lib.platforms.unix;
  };
})
