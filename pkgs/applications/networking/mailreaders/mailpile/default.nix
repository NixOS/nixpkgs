{ stdenv, fetchFromGitHub, python2Packages, gnupg1orig, openssl, git }:

python2Packages.buildPythonApplication rec {
  name = "mailpile-${version}";
  version = "0.5.x-git-master-20170301";

  src = fetchFromGitHub {
    owner = "mailpile";
    repo = "Mailpile";
    rev = "523c9719c12303b7926b59913599ce50b601bc3f";
    sha256 = "15g8va96cdab60zr17ndm8f2jw7x7l97j4ssz19mcjm60vqni0ih";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "data_files.append((dir" "data_files.append(('lib/${python2Packages.python.libPrefix}/site-packages/' + dir"
    patchShebangs scripts
  '';
  PBR_VERSION=version;

  buildInputs = with python2Packages; [ pbr git ];

  propagatedBuildInputs = with python2Packages; [
    cryptography
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
