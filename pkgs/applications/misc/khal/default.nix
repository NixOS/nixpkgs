{ lib, stdenv, pkgs, python3, fetchpatch, glibcLocales }:

with python3.pkgs; buildPythonApplication rec {
  pname = "khal";
  version = "0.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-L92PwU/ll+Wn1unGPHho2WC07QIbVjxoSnHwcJDtpDI=";
  };

  patches = [
    ./skip-broken-test.patch
  ];

  propagatedBuildInputs = [
    atomicwrites
    click
    click-log
    configobj
    dateutil
    icalendar
    lxml
    pkgs.vdirsyncer
    pytz
    pyxdg
    requests_toolbelt
    tzlocal
    urwid
    pkginfo
    freezegun
  ];
  nativeBuildInputs = [ setuptools_scm sphinx sphinxcontrib_newsfeed ];
  checkInputs = [ pytest glibcLocales ];
  LC_ALL = "en_US.UTF-8";

  postPatch = ''
    sed -i \
      -e "s/Invalid value for \"ics\"/Invalid value for \\\'ics\\\'/" \
      -e "s/Invalid value for \"\[ICS\]\"/Invalid value for \\\'\[ICS\]\\\'/" \
      tests/cli_test.py
  '';

  postInstall = ''
    # zsh completion
    install -D misc/__khal $out/share/zsh/site-functions/__khal

    # man page
    PATH="${python3.withPackages (ps: with ps; [ sphinx sphinxcontrib_newsfeed ])}/bin:$PATH" \
    make -C doc man
    install -Dm755 doc/build/man/khal.1 -t $out/share/man/man1

    # desktop
    install -Dm755 misc/khal.desktop -t $out/share/applications
  '';

  doCheck = !stdenv.isAarch64;

  checkPhase = ''
    py.test -k "not test_vertical_month_abbr_fr and not test_vertical_month_unicode_weekdeays_gr \
      and not test_event_different_timezones and not test_default_calendar and not test_birthdays \
      and not test_birthdays_no_year"
  '';

  meta = with lib; {
    homepage = "http://lostpackets.de/khal/";
    description = "CLI calendar application";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
