{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  exiv2,
  flex,
  libewf,
  libxml2,
  openssl,
  zlib,
  pkg-config,
  python3,
  re2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bulk_extractor";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "simsong";
    repo = "bulk_extractor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jj/amXESFBu/ZaiIRlDKmtWTBVQ2TEvOM2jBYP3y1L8=";
    fetchSubmodules = true;
  };

  # Fix gcc15 build failures due to missing <cstdint>
  # Tracking: https://github.com/NixOS/nixpkgs/issues/475479
  postPatch = ''
    sed -i '1i #include <cstdint>' src/exif_entry.h
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/be20_api/feature_recorder_set.cpp --replace-fail '#warn ' '#warning '
  '';

  enableParallelBuilding = true;
  nativeBuildInputs = [
    pkg-config
    python3
    autoreconfHook
  ];
  buildInputs = [
    exiv2
    flex
    libewf
    libxml2
    openssl
    zlib
    re2
  ];

  preAutoreconf = ''
    python3 etc/makefile_builder.py
    autoheader -f
    aclocal -I m4
  '';

  meta = {
    description = "Digital forensics tool for extracting information from file systems";
    longDescription = ''
      bulk_extractor is a C++ program that scans a disk image, a file, or a
      directory of files and extracts useful information without parsing
      the file system or file system structures. The results are stored in
      feature files that can be easily inspected, parsed, or processed with
      automated tools.
    '';
    mainProgram = "bulk_extractor";
    homepage = "https://github.com/simsong/bulk_extractor";
    downloadPage = "http://downloads.digitalcorpora.org/downloads/bulk_extractor/";
    changelog = "https://github.com/simsong/bulk_extractor/blob/${finalAttrs.src.rev}/ChangeLog";
    maintainers = [ ];
    platforms = with lib.platforms; unix ++ windows;
    license = with lib.licenses; [
      mit
      cpl10
      gpl3Only
      lgpl21Only
      lgpl3Only
      lib.licenses.openssl
    ];
  };
})
