{
  lib,
  fetchPypi,
  buildPythonPackage,
  html5lib,
  httplib2,
  nose,
  pillow,
  pypdf2,
  reportlab,
}:

let
  #xhtml2pdf specifically requires version "1.0b10" of html5lib
  html5 = html5lib.overrideAttrs (oldAttrs: rec {
    name = "${oldAttrs.pname}-${version}";
    version = "1.0b10";
    src = oldAttrs.src.override {
      inherit version;
      sha256 = "1yd068a5c00wd0ajq0hqimv7fd82lhrw0w3s01vbhy9bbd6xapqd";
    };
  });
in

buildPythonPackage rec {
  pname = "xhtml2pdf";
  version = "0.2.1";

  buildInputs = [ html5 ];
  propagatedBuildInputs = [
    httplib2
    nose
    pillow
    pypdf2
    reportlab
    html5
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n9r8zdk9gc2x539fq60bhszmd421ipj8g78zmsn3njvma1az9k1";
  };

  meta = {
    description = "A pdf converter for the ReportLab Toolkit";
    homepage = "https://github.com/xhtml2pdf/xhtml2pdf";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
