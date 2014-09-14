{ stdenv, fetchurl, pythonPackages, gnupg1orig, makeWrapper }:

pythonPackages.buildPythonPackage rec {
  name = "mailpile-${version}";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/pagekite/Mailpile/archive/${version}.zip";
    sha256 = "1di859lnhmlih4byfpsj8x6wjvzrddw0ng0w69bsj5f9bdy4rgq4";
  };
  
  patchPhase = ''
    substituteInPlace setup.py --replace "data_files.append((dir" "data_files.append(('lib/${pythonPackages.python.libPrefix}/site-packages/' + dir"
  '';

  propagatedBuildInputs = with pythonPackages; [
    makeWrapper pillow jinja2 spambayes pythonPackages.lxml
    python.modules.readline pgpdump gnupg1orig
  ];

  postInstall = ''
    wrapProgram $out/bin/mailpile --prefix PATH ":" "${gnupg1orig}/bin"
  '';

  meta = with stdenv.lib; {
    description = "A modern, fast web-mail client with user-friendly encryption and privacy features";
    homepage = https://www.mailpile.is/;
    license = map (getAttr "shortName") [ licenses.asl20 licenses.agpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.iElectric ];
  };
}