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
    version = "${year}.1.2";
    desktopName = "PDF Studio";
    longDescription = ''
      PDF Studio is an easy to use, full-featured PDF editing software. This is the standard/pro edition, which requires a license. For the free PDF Studio Viewer see the package pdfstudioviewer.
    '';
    extraBuildInputs = [
      libgccjit #for libstdc++.so.6 and libgomp.so.1
    ];
    src = fetchurl {
      url = makeurl { inherit pname year version; };
      sha256 = "1188ll2qz58rr2slavqxisbz4q3fdzidpasb1p33926z0ym3rk45";
    };
  };

  pdfstudioviewer = callPackage ./common.nix rec {
    pname = program;
    year = "2021";
    version = "${year}.1.2";
    desktopName = "PDF Studio Viewer";
    longDescription = ''
      PDF Studio Viewer is an easy to use, full-featured PDF editing software. This is the free edition. For the standard/pro edition, see the package pdfstudio.
    '';
    src = fetchurl {
      url = makeurl { inherit pname year version; };
      sha256 = "128k3fm8m8zdykx4s30g5m2zl7cgmvs4qinf1w525zh84v56agz6";
    };
  };
}.${program}
