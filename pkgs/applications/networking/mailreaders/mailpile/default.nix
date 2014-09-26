{ stdenv, fetchgit, pythonPackages, gnupg1orig, makeWrapper, openssl }:

pythonPackages.buildPythonPackage rec {
  name = "mailpile-${version}";
  version = "0.4.0";

  src = fetchgit {
    url = "git://github.com/pagekite/Mailpile";
    rev = "af3e2554dcef892cc44e044ce61e1693f09228c0";
    sha256 = "0p8j5w5281rjl0nigsw7glfp7inz13p6iqlr9g3m3vh72i9pvl7h";
  };
  
  patchPhase = ''
    substituteInPlace setup.py --replace "data_files.append((dir" "data_files.append(('lib/${pythonPackages.python.libPrefix}/site-packages/' + dir"
  '';

  propagatedBuildInputs = with pythonPackages; [
    makeWrapper pillow jinja2 spambayes pythonPackages.lxml
    python.modules.readline pgpdump gnupg1orig
  ];

  postInstall = ''
    wrapProgram $out/bin/mailpile \
      --prefix PATH ":" "${gnupg1orig}/bin:${openssl}/bin"
  '';

  meta = with stdenv.lib; {
    description = "A modern, fast web-mail client with user-friendly encryption and privacy features";
    homepage = https://www.mailpile.is/;
    license = map (getAttr "shortName") [ licenses.asl20 licenses.agpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.iElectric ];
  };
}