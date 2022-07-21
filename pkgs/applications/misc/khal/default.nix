{ lib, stdenv, pkgs, python3, fetchpatch, glibcLocales, installShellFiles }:

with python3.pkgs; buildPythonApplication rec {
  pname = "khal";
  version = "0.10.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Tu+3rDAqJthgbbOSgXWHpO2UwnoVvy6iEWFKRk/PDHY=";
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
  nativeBuildInputs = [ setuptools-scm sphinx sphinxcontrib_newsfeed installShellFiles ];

  postInstall = ''
    # shell completions
    installShellCompletion --cmd khal \
      --bash <(_KHAL_COMPLETE=bash_source $out/bin/khal) \
      --fish <(_KHAL_COMPLETE=zsh_source $out/bin/khal) \
      --zsh <(_KHAL_COMPLETE=fish_source $out/bin/khal)

    # man page
    PATH="${python3.withPackages (ps: with ps; [ sphinx sphinxcontrib_newsfeed ])}/bin:$PATH" \
    make -C doc man
    install -Dm755 doc/build/man/khal.1 -t $out/share/man/man1

    # desktop
    install -Dm755 misc/khal.desktop -t $out/share/applications
  '';

  doCheck = !stdenv.isAarch64;

  checkInputs = [
    glibcLocales
    pytestCheckHook
  ];

  LC_ALL = "en_US.UTF-8";

  disabledTests = [
    # timing based
    "test_etag"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "http://lostpackets.de/khal/";
    description = "CLI calendar application";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
