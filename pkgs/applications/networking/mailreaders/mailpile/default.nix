{ lib, fetchFromGitHub, python2Packages, gnupg1orig, openssl, git }:

python2Packages.buildPythonApplication rec {
  pname = "mailpile";
  version = "1.0.0rc2";

  src = fetchFromGitHub {
    owner = "mailpile";
    repo = "Mailpile";
    rev = version;
    sha256 = "1z5psh00fjr8gnl4yjcl4m9ywfj24y1ffa2rfb5q8hq4ksjblbdj";
  };

  postPatch = ''
    patchShebangs scripts
  '';

  nativeBuildInputs = with python2Packages; [ pbr git ];
  PBR_VERSION=version;

  propagatedBuildInputs = with python2Packages; [
    appdirs
    cryptography
    fasteners
    gnupg1orig
    jinja2
    pgpdump
    pillow
    python2Packages.lxml
    spambayes
  ];

  postInstall = ''
    wrapProgram $out/bin/mailpile \
      --prefix PATH ":" "${lib.makeBinPath [ gnupg1orig openssl ]}" \
      --set-default MAILPILE_SHARED "$out/share/mailpile"
  '';

  # No tests were found
  doCheck = false;

  meta = with lib; {
    description = "A modern, fast web-mail client with user-friendly encryption and privacy features";
    homepage = "https://www.mailpile.is/";
    license = [ licenses.asl20 licenses.agpl3 ];
    platforms = platforms.linux;
    maintainers = [ ];
    knownVulnerabilities = [
      "Numerous and uncounted, upstream has requested we not package it. See more: https://github.com/NixOS/nixpkgs/pull/23058#issuecomment-283515104"
    ];
  };
}
