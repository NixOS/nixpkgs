{ lib, fetchFromGitHub, python2Packages, gnupg, openssl, git, tor }:

python2Packages.buildPythonApplication rec {
  pname = "mailpile";
  version = "1.0.0rc6";

  src = fetchFromGitHub {
    owner = "mailpile";
    repo = "Mailpile";
    rev = version;
    sha256 = "pw0DRwAeOHRKcgI3C/D0DU0rKrfPCI/Qfj8//J4fCsw=";
    fetchSubmodules = true;
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
    jinja2
    pgpdump
    pillow
    lxml
    spambayes
    stem
    imgsize
    icalendar
    pysocks
  ];

  outputs = [ "out" "doc" ];

  postInstall = ''
    wrapProgram $out/bin/mailpile \
      --prefix PATH ":" "${lib.makeBinPath [ gnupg openssl tor ]}" \
      --set-default MAILPILE_SHARED "$out/share/mailpile"

      # Install package documentation
      mkdir -p $doc/share/doc/mailpile
      cp -r -t $doc/share/doc/mailpile $src/doc/*
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
