{ stdenv, fetchgit, python2Packages, gnupg1orig, openssl }:

python2Packages.buildPythonApplication rec {
  name = "mailpile-${version}";
  version = "0.5.2";

  src = fetchgit {
    url = "https://github.com/mailpile/Mailpile";
    rev = "refs/tags/${version}";
    sha256 = "1d2b776x9134sv67pylfkvf1dd4vs5pvgrngpmshrsjgsib13dx5";
  };

  patchPhase = ''
    substituteInPlace setup.py --replace "data_files.append((dir" "data_files.append(('lib/${python2Packages.python.libPrefix}/site-packages/' + dir"
    patchShebangs scripts
  '';

  propagatedBuildInputs = with python2Packages; [
    pillow jinja2 spambayes python2Packages.lxml
    pgpdump gnupg1orig
  ];

  postInstall = ''
    wrapProgram $out/bin/mailpile \
      --prefix PATH ":" "${stdenv.lib.makeBinPath [ gnupg1orig openssl ]}"
  '';

  # No tests were found
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A modern, fast web-mail client with user-friendly encryption and privacy features";
    homepage = https://www.mailpile.is/;
    license = [ licenses.asl20 licenses.agpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.domenkozar ];
  };
}
