{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "makedepend";
  version = "1.0.9";

  src = fetchurl {
    url = "mirror://xorg/individual/util/makedepend-${finalAttrs.version}.tar.xz";
    hash = "sha256-ktDetln/9tjdvB0n/EyozrK22+Fdc/CgTtwJ8cV4LdQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

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
    description = "Parse C sources to make dependency lists for Makefiles";
    homepage = "https://gitlab.freedesktop.org/xorg/util/makedepend";
    license = with lib.licenses; [
      mitOpenGroup
      hpnd
    ];
    mainProgram = "makedepend";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
