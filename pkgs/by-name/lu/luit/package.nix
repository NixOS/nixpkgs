{
  lib,
  stdenv,
  writeScript,
  pkg-config,
  fetchurl,
  libiconv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "luit";
  version = "20240910";

  src = fetchurl {
    url = "https://invisible-mirror.net/archives/luit/luit-${finalAttrs.version}.tgz";
    hash = "sha256-oV1/y/wlrhRT1hrsI/9roEFF1ue3s7AHHrXP2jo6SdU=";
  };
  hardeningDisable = [
    "bindnow"
    "relro"
  ];
  strictDeps = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libiconv ];

  passthru.updateScript = writeScript "update-luit" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p common-updater-scripts

    version="$(list-directory-versions --pname luit | sort | tail -n1)"

    update-source-version luit "$version"
  '';

  meta = {
    description = "Filter between an arbitrary application and a UTF-8 terminal emulator converting the output and input between the locale's encoding and UTF-8";
    homepage = "https://invisible-island.net/luit/";
    # the website says it is licensed MIT-X11, but there are multiple licenses contained in the tarball
    license = with lib.licenses; [
      # some of them are supposed to be MIT-X11, but don't have the X11 specific section in their license
      # MIT-X11 without the section is just MIT
      mit
      x11
      # 2 files are gpl3+
      gpl3Plus
    ];
    mainProgram = "luit";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
