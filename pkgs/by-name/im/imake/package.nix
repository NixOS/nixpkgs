{
  lib,
  stdenv,
  fetchurl,
  tradcpp,
  xorg-cf-files,
  pkg-config,
  xorgproto,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "imake";
  version = "1.0.10";

  src = fetchurl {
    url = "mirror://xorg/individual/util/imake-${finalAttrs.version}.tar.xz";
    hash = "sha256-dd7LzqjXs1TPNq3JZ15TxHkO495WoUvYe0LI6KrS7PU=";
  };

  patches = [
    ./imake.patch
    ./imake-cc-wrapper-uberhack.patch
  ];

  strictDeps = true;

  inherit tradcpp xorg-cf-files;
  setupHook = ./imake-setup-hook.sh;
  x11BuildHook = ./imake.sh;

  configureFlags = [
    "ac_cv_path_RAWCPP=${stdenv.cc.targetPrefix}cpp"
  ];
  CFLAGS = "-DIMAKE_COMPILETIME_CPP='\"${
    if stdenv.hostPlatform.isDarwin then "${tradcpp}/bin/cpp" else "gcc"
  }\"'";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ xorgproto ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/util/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "Obsolete C preprocessor interface to the make utility";
    homepage = "https://gitlab.freedesktop.org/xorg/util/imake";
    license = with lib.licenses; [
      mitOpenGroup
      x11
    ];
    mainProgram = "imake";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
