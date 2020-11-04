{ stdenv, pkgs, python3, fetchpatch, glibcLocales }:

with python3.pkgs; buildPythonApplication rec {
  pname = "khal";
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11qhrga44knlnp88py9p547d4nr5kn041d2nszwa3dqw7mf22ks9";
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
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = "http://lostpackets.de/khal/";
    description = "CLI calendar application";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
