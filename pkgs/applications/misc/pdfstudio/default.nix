{ program ? "pdfstudioviewer"
, fetchurl
, libgccjit
, callPackage
}:

let makeurl = { pname, year, version }: "https://download.qoppa.com/${pname}/v${year}/${
    builtins.replaceStrings [ "pdfstudio" "viewer" "." ] [ "PDFStudio" "Viewer" "_" ] "${pname}_v${version}"
  }_linux64.deb";
in
{
  pdfstudio = callPackage ./common.nix rec {
    pname = program;
    year = "2021";
    version = "${year}.2.0";
    desktopName = "PDF Studio";
    longDescription = ''
      PDF Studio is an easy to use, full-featured PDF editing software. This is the standard/pro edition, which requires a license. For the free PDF Studio Viewer see the package pdfstudioviewer.
    '';
    extraBuildInputs = [
      libgccjit #for libstdc++.so.6 and libgomp.so.1
    ];
    src = fetchurl {
      url = makeurl { inherit pname year version; };
      sha256 = "sha256-wQgVWz2kS+XkrqvCAUishizfDrCwGyVDAAU4Yzj4uYU=";
    };
  };

  pdfstudioviewer = callPackage ./common.nix rec {
    pname = program;
    year = "2021";
    version = "${year}.2.0";
    desktopName = "PDF Studio Viewer";
    longDescription = ''
      PDF Studio Viewer is an easy to use, full-featured PDF editing software. This is the free edition. For the standard/pro edition, see the package pdfstudio.
    '';
    src = fetchurl {
      url = makeurl { inherit pname year version; };
      sha256 = "sha256-RjVfl3wRK4bqNwSZr2R0CNx4urHTL0QLmKdogEnySWU=";
    };
  };
}.${program}
