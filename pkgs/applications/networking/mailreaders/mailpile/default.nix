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
    longDescription = ''
      Mailpile (https://www.mailpile.is/) is a modern, fast web-mail client with user-friendly
      encryption and privacy features. The development of Mailpile is funded by a large community
      of backers and all code related to the project is and will be released under an OSI approved
      Free Software license.

      Mailpile places great emphasis on providing a clean, elegant user interface and pleasant
      user experience. In particular, Mailpile aims to make it easy and convenient to receive and
      send PGP encrypted or signed e-mail.

      Mailpile's primary user interface is web-based, but it also has a basic command-line interface
      and an API for developers. Using web technology for the interface allows Mailpile to function
      both as a local desktop application (accessed by visiting localhost in the browser) or a remote
      web-mail on a personal server or VPS.

      The core of Mailpile is a fast search engine, custom written to deal with large volumes of
      e-mail on consumer hardware. The search engine allows e-mail to be organized using tags (similar
      to GMail's labels) and the application can be configured to automatically tag incoming mail
      either based on static rules or bayesian classifiers.

      Note: We are currently working towards a 1.0 release candidate. Until it is ready, Mailpile is
      really only suitable for developers who can help us find and fix the last few bugs. Our beta
      releases are obsolete and should not be used, in part for security reasons! For more details
      follow @MailpileTeam on Twitter or read our blog.
    '';
  };
}
