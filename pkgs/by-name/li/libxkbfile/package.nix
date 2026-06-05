{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxkbfile";
  version = "1.1.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libxkbfile-${finalAttrs.version}.tar.xz";
    hash = "sha256-qbY+6pl6u57mqLT7tRWDHIQfRxr4RaCd5EOygAOHS+w=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
  ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "XKB file handling routines";
    longDescription = ''
      libxkbfile is used by the X servers and utilities to parse the XKB configuration data files.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxkbfile";
    license = with lib.licenses; [
      hpnd
      mitOpenGroup
    ];
    maintainers = [ ];
    pkgConfigModules = [ "xkbfile" ];
    platforms = lib.platforms.unix;
  };
})
