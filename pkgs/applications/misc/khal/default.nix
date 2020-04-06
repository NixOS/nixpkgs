{ stdenv, pkgs, python3, fetchpatch, glibcLocales }:

with python3.pkgs; buildPythonApplication rec {
  pname = "khal";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1r8bkgjwkh7i8ygvsv51h1cnax50sb183vafg66x5snxf3dgjl6l";
  };

  # Include a khal.desktop file via upstream commit.
  # This patch should be removed when updating to the next version, probably.
  patches = [
    (fetchpatch {
      name = "add-khal-dot-desktop.patch";
      url = "https://github.com/pimutils/khal/commit/1f93d238fec7c934dd2f8e48f54925d22130e3aa.patch";
      sha256 = "06skn3van7zd93348fc6axllx71ckkc7h2zljqlvwa339vca608c";
    })
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
    homepage = http://lostpackets.de/khal/;
    description = "CLI calendar application";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
