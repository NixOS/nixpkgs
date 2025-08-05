{
  lib,
  stdenv,
  callPackage,
  perl,
  which,
  coreutils,
  zenity,
  curl,
  cabextract,
  unzip,
  p7zip,
  gnused,
  gnugrep,
  bash,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "winetricks";
  version = src.version;

  src = (callPackage ./sources.nix { }).winetricks;

  patches = [
    (fetchpatch {
      # make WINE_BIN and WINESERVER_BIN overridable
      # see https://github.com/NixOS/nixpkgs/issues/338367
      url = "https://github.com/Winetricks/winetricks/commit/1d441b422d9a9cc8b0a53fa203557957ca1adc44.patch";
      hash = "sha256-AYXV2qLHlxuyHC5VqUjDu4qi1TcAl2pMSAi8TEp8db4=";
    })
  ];

  buildInputs = [
    perl
    which
  ];

  # coreutils is for sha1sum
  pathAdd = lib.makeBinPath [
    perl
    which
    coreutils
    zenity
    curl
    cabextract
    unzip
    p7zip
    gnused
    gnugrep
    bash
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = false; # requires "bashate"

  postInstall = ''
    sed -i \
      -e '2i PATH="${pathAdd}:$PATH"' \
      -e '2i : "''${WINESERVER_BIN:=/run/current-system/sw/bin/wineserver}"' \
      -e '2i : "''${WINE_BIN:=/run/current-system/sw/bin/.wine}"' \
      "$out/bin/winetricks"
  '';

  passthru = {
    inherit (src) updateScript;
  };

  meta = {
    description = "Script to install DLLs needed to work around problems in Wine";
    mainProgram = "winetricks";
    license = lib.licenses.lgpl21;
    homepage = "https://github.com/Winetricks/winetricks";
    platforms = with lib.platforms; linux ++ darwin;
  };
}
