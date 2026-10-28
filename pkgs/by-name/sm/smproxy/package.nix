{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libice,
  libsm,
  libxmu,
  libxt,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "smproxy";
  version = "1.0.8";

  src = fetchurl {
    url = "mirror://xorg/individual/app/smproxy-${finalAttrs.version}.tar.xz";
    hash = "sha256-/uWE6uLsHOLReNctO0hJICcbpoonk1dpzvuvvDov9sg=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libice
    libsm
    libxmu
    libxt
  ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/app/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "allows X applications that do not support X11R6 session management to participate in an X11R6 session";
    homepage = "https://gitlab.freedesktop.org/xorg/app/smproxy";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "smproxy";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
