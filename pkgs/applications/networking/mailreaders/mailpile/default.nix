{ stdenv
, fetchFromGitHub
, python2Packages
, gnupg
, openssl
, git
, tor
}:

python2Packages.buildPythonApplication rec {
  pname = "mailpile";
  version = "1.0.0rc6";

  src = fetchFromGitHub {
    owner = "mailpile";
    repo = "Mailpile";
    rev = version;
    sha256 = "13pj494dx5gjf6x4bazh586vqmaqq8ycvw2k65280md1yc79b6l1";
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
    gnupg
    jinja2
    pgpdump
    pillow
    lxml
    spambayes
    stem
    pysocks
    icalendar
    imgsize
  ];

  patches = [ ./underscores.patch ];

  postInstall = ''
    wrapProgram $out/bin/mailpile \
      --set-default MAILPILE_GNUPG "${gnupg}/bin/gpg" \
      --set-default MAILPILE_GNUPG_GA "${gnupg}/bin/gpg-agent" \
      --set-default MAILPILE_GNUPG_DM "${gnupg}/bin/dirmngr" \
      --set-default MAILPILE_OPENSSL "${openssl}/bin/openssl" \
      --set-default MAILPILE_TOR "${tor}/bin/tor" \
      --set-default MAILPILE_SHARED "$out/share/mailpile"
  '';

  # No tests were found
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A modern, fast web-mail client with user-friendly encryption and privacy features";
    homepage = "https://www.mailpile.is/";
    license = [ licenses.asl20 licenses.agpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.domenkozar ];
  };
}
