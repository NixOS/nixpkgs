{
  stdenv,
  lib,
  autoPatchelfHook,
  dpkg,
  pkgs,
  fetchurl
}:

stdenv.mkDerivation rec {

  pname = "positron";
  version = "2024.08.0-31";
  POSITRON_VERSION_MAJOR = lib.versions.major version;
  POSITRON_VERSION_MINOR = lib.versions.minor version;
  POSITRON_VERSION_PATCH = lib.versions.patch version;
  POSITRON_VERSION_SUFFIX = "+" + toString (lib.tail (lib.splitString "+" version));

  outputs = [ "out" ];

  src = fetchurl {
    url = "https://github.com/posit-dev/positron/releases/download/${version}/Positron-${version}.deb";
    hash = "sha256-8LckYQ++uv8fOHOBLaPAJfcJM0/Fc6YMKhAsXHFI/nY=";
  };

  buildInputs = with pkgs; [
    stdenv.cc.cc
    libkrb5 xorg.libX11
    xorg.libxkbfile
    xorg.libXcomposite
    xorg.libXdamage
    libxkbcommon
    libdrm
    gtk3
    nss
    mesa
    alsa-lib
    musl
    expat
    pango
    cairo
    openssl
    xorg.libXfixes
    xorg.libXrandr
  ];

  nativeBuildInputs = [ dpkg autoPatchelfHook ];

  unpackPhase = "
    runHook preUnpack

    # The deb file contains a setuid binary, so 'dpkg -x' doesn't work here
    dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
    runHook postUnpack
    ";

  installPhase = "
    runHook preInstall

    mkdir -p $out $out/bin $out/share

    mv usr/share/* $out/share/

    ln -s $out/share/positron/bin/positron $out/bin/positron

    runHook postInstall
    ";

  meta = {
    description = "Positron, a next-generation data science IDE";
    longDescription = ''
      Positron is an extensible, polyglot IDE built by Posit PBC.
    '';
    homepage = "https://github.com/posit-dev/positron";
    license = lib.licenses.elastic20;
    maintainers = with lib.maintainers; [ b-rodrigues ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
