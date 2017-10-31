{ stdenv, fetchgit, python2Packages, gnupg1orig, makeWrapper, openssl }:

python2Packages.buildPythonApplication rec {
  name = "mailpile-${version}";
  version = "0.4.1";

  src = fetchgit {
    url = "git://github.com/pagekite/Mailpile";
    rev = "refs/tags/${version}";
    sha256 = "118b5zwfwmzj38p0mkj3r1s09jxg8x38y0a42b21imzpmli5vpb5";
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
