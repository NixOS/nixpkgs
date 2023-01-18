# For upstream versions, download links, and change logs see https://www.qoppa.com/pdfstudio/versions
#
# PDF Studio license is for a specific year, so we need different packages for different years.
# All versions of PDF Studio Viewer are free, so we package only the latest year.
# Thus, packages are pdfstudioviewer, pdfstudio2021, pdfstudio2022, etc.
# Variables:
# - program is either "pdfstudio" or "pdfstudioviewer", defaults to "pdfstudio".
# - year identifies the year portion of the version, defaults to most recent year.
# - pname is either "pdfstudio${year}" or "pdfstudioviewer".

{ lib
, program ? "pdfstudio"
, year ? "2022"
, fetchurl
, gcc
, callPackage
, jdk11
, jdk17
}:
let
  longDescription = ''
    PDF Studio is an easy to use, full-featured PDF editing software. This is the standard/pro edition, which requires a license. For the free PDF Studio Viewer see the package pdfstudioviewer.
  '';
  pname = if (program == "pdfstudio") then "${program}${year}" else program;
  desktopName =
    if (program == "pdfstudio")
    then "PDF Studio ${year}"
    else "PDF Studio Viewer";
  dot2dash = str: builtins.replaceStrings [ "." ] [ "_" ] str;
in
{
  pdfstudioviewer = callPackage ./common.nix rec {
    inherit desktopName pname program year;
    version = "${year}.1.0";
    longDescription = ''
      PDF Studio Viewer is an easy to use, full-featured PDF editing software. This is the free edition. For the standard/pro edition, see the package pdfstudio.
    '';
    src = fetchurl {
      url = "https://web.archive.org/web/20220909093140/https://download.qoppa.com/pdfstudioviewer/PDFStudioViewer_linux64.deb";
      sha256 = "sha256-za+a5vGkINLFvFoZdnB++4VGE9rfdfZf5HFNw/Af1AA=";
    };
    jdk = jdk11;
  };

  pdfstudio2021 = callPackage ./common.nix rec {
    inherit desktopName longDescription pname program year;
    version = "${year}.2.0";
    src = fetchurl {
      url = "https://download.qoppa.com/pdfstudio/v${year}/PDFStudio_v${dot2dash version}_linux64.deb";
      sha256 = "sha256-wQgVWz2kS+XkrqvCAUishizfDrCwGyVDAAU4Yzj4uYU=";
    };
    extraBuildInputs = [
      (lib.getLib gcc)  # for libstdc++.so.6 and libgomp.so.1
    ];
    jdk = jdk11;
  };

  pdfstudio2022 = callPackage ./common.nix rec {
    inherit desktopName longDescription pname program year;
    version = "${year}.1.3";
    src = fetchurl {
      url = "https://download.qoppa.com/pdfstudio/v${year}/PDFStudio_v${dot2dash version}_linux64.deb";
      sha256 = "sha256-B3RrftuKsPWUWP9hwnq4i311hgZgwZLqG1pJLdilfQI=";
    };
    extraBuildInputs = [
      (lib.getLib gcc)  # for libstdc++.so.6 and libgomp.so.1
    ];
    jdk = jdk17;
  };
}.${pname}
