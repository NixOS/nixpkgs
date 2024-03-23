{ lib, finalAttrs }:
{
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
    maintainers = with maintainers; [ d3vil0p3r h7x4 ];
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
}
