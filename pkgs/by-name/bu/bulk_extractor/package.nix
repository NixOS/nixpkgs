{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, exiv2
, flex
, libewf
, libxml2
, openssl
, tre
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bulk_extractor";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "simsong";
    repo = "bulk_extractor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LNdRN4pEA0rVEyKiBKGJgTKA4veVvsuP3ufiolHTk/s=";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    exiv2
    flex
    libewf
    libxml2
    openssl
    tre
    zlib
  ];

  meta = with lib; {
    description = "A digital forensics tool for extracting information from file systems";
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
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = with platforms; unix ++ windows;
    license = with licenses; [
      mit
      cpl10
      gpl3Only
      lgpl21Only
      lgpl3Only
      licenses.openssl
    ];
  };
})
