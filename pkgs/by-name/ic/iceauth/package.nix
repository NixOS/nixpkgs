{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libice,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "iceauth";
  version = "1.0.10";

  src = fetchurl {
    url = "mirror://xorg/individual/app/iceauth-${finalAttrs.version}.tar.xz";
    hash = "sha256-Pe77faJq+dx5m1Yo2SnZHJr2jHhXVjmUTbO5VfKaoCk=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libice
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
    description = "libICE authority file utility";
    longDescription = ''
      The iceauth program is used to edit and display the authorization information used in
      connecting with ICE (the X11 Inter-Client Exchange protocol). It operates very much like the
      xauth program for X11 connection authentication records.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/iceauth";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "iceauth";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
