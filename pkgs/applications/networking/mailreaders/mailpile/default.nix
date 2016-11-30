{ stdenv, fetchgit, python2Packages, gnupg1orig, makeWrapper, openssl }:

python2Packages.buildPythonApplication rec {
  name = "mailpile-${version}";
  version = "0.5.2";

  src = fetchgit {
    url = "git://github.com/pagekite/Mailpile";
    rev = "refs/tags/${version}";
    sha256 = "1d2b776x9134sv67pylfkvf1dd4vs5pvgrngpmshrsjgsib13dx5";
  };

  patchPhase = ''
    patchShebangs scripts
    substituteInPlace setup.py --replace "data_files.append((dir" "data_files.append(('lib/${pythonPackages.python.libPrefix}/site-packages/' + dir"
  '';

  buildInputs = with pythonPackages; [ nose mock ];
  propagatedBuildInputs = with pythonPackages; [
    makeWrapper pillow jinja2 spambayes pythonPackages.lxml
    pgpdump gnupg1orig
  ];

  postInstall = ''
    wrapProgram $out/bin/mailpile \
      --prefix PATH ":" "${stdenv.lib.makeBinPath [ gnupg1orig openssl ]}"
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A modern, fast web-mail client with user-friendly encryption and privacy features";
    homepage = https://www.mailpile.is/;
    license = [ licenses.asl20 licenses.agpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.domenkozar ];
  };
}
