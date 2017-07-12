{ stdenv, fetchFromGitHub, python2Packages, gnupg1orig, makeWrapper, openssl }:

python2Packages.buildPythonApplication rec {
  name = "mailpile-${version}";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "pagekite";
    repo = "Mailpile";
    rev = "refs/tags/${version}";
    sha256 = "09a3y5lyr1z9wszi8zcpchqv8caapz52d1cs5c1ayn1hvay5c9wy";
  };

  patchPhase = ''
    substituteInPlace setup.py --replace "data_files.append((dir" "data_files.append(('lib/${python2Packages.python.libPrefix}/site-packages/' + dir"
  '';

  propagatedBuildInputs = with python2Packages; [
    makeWrapper pillow jinja2 spambayes python2Packages.lxml
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
    knownVulnerabilities = [
      "Numerous and uncounted, upstream has requested we not package it. See more: https://github.com/NixOS/nixpkgs/pull/23058#issuecomment-283515104"
    ];
  };
}
