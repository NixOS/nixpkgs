{ lib, stdenv, pkgs, python3, fetchpatch, glibcLocales }:

with python3.pkgs; buildPythonApplication rec {
  pname = "khal";
  version = "0.10.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3fdb980a9a61c0206d7a82b16f77b408a4f341a2b866b9c9fcf6a641850d129f";
  };

  propagatedBuildInputs = [
    atomicwrites
    click
    click-log
    configobj
    python-dateutil
    icalendar
    lxml
    pkgs.vdirsyncer
    pytz
    pyxdg
    requests-toolbelt
    tzlocal
    urwid
    pkginfo
    freezegun
  ];
  nativeBuildInputs = [ setuptools-scm sphinx sphinxcontrib_newsfeed ];
  checkInputs = [
    glibcLocales
    pytestCheckHook
  ];
  LC_ALL = "en_US.UTF-8";

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

  disabledTests = [
    # This test is failing due to https://github.com/pimutils/khal/issues/1065
    "test_print_ics_command"

    # Mocking breaks in this testcase
    "test_import_from_stdin"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "http://lostpackets.de/khal/";
    description = "CLI calendar application";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
