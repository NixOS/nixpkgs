{
  lib,
  python3,
  fetchurl,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "csv2odf";
  version = "2.09";
  format = "pyproject";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "09l0yfay89grjdzap2h11f0hcyn49np5zizg2yyp2aqgjs8ki57p";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  meta = with lib; {
    homepage = "https://sourceforge.net/p/csv2odf/wiki/Main_Page/";
    description = "Convert csv files to OpenDocument Format";
    mainProgram = "csv2odf";
    longDescription = ''
      csv2odf is a command line tool that can convert a comma separated value
      (csv) file to an odf, ods, html, xlsx, or docx document that can be viewed in
      LibreOffice and other office productivity programs. csv2odf is useful for
      creating reports from databases and other data sources that produce csv files.
      csv2odf can be combined with cron and shell scripts to automatically generate
      business reports.

      The output format (fonts, number formatting, etc.) is controlled by a
      template file that you can design in your office application of choice.
    '';
    license = licenses.gpl3;
  };
}
