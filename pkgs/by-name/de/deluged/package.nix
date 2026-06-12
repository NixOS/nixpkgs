{
  lib,
  fetchurl,
  intltool,
  libtorrent-rasterbar,
  python3Packages,
  glib,
  gobject-introspection,
  librsvg,
  nixosTests,
}:

let
  pypkgs = python3Packages;
in

pypkgs.buildPythonPackage (finalAttrs: {
  pname = "deluged";
  version = "2.2.0";
  format = "setuptools";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "http://download.deluge-torrent.org/source/${lib.versions.majorMinor finalAttrs.version}/deluge-${finalAttrs.version}.tar.xz";
    hash = "sha256-ubonK1ukKq8caU5sKWKKuBbMGnAKN7rAiqy1JXFgas0=";
  };

  propagatedBuildInputs = with pypkgs; [
    twisted
    mako
    chardet
    pyxdg
    pyopenssl
    service-identity
    libtorrent-rasterbar.dev
    libtorrent-rasterbar.python
    setuptools
    setproctitle
    pillow
    rencode
    six
    zope-interface
    dbus-python
    pycairo
    librsvg
  ];

  nativeBuildInputs = [
    intltool
    glib
  ];

  nativeCheckInputs = with pypkgs; [
    pytestCheckHook
    pytest-twisted
    pytest-cov-stub
    mock
    mccabe
    pylint
  ];

  doCheck = false; # tests are not working at all

  postInstall = ''
    install -Dm444 -t $out/lib/systemd/system packaging/systemd/*.service
    rm -rf $out/bin/deluge-gtk
    rm -rf $out/${python3Packages.python.sitePackages}/deluge/ui/gtk3
    rm -rf $out/share/icons $out/share/pixmaps $out/share/man/man1/deluge-gtk*
  '';

  postFixup = ''
    for f in $out/lib/systemd/system/*; do
      substituteInPlace $f --replace /usr/bin $out/bin
    done
  '';

  passthru.tests = { inherit (nixosTests) deluge; };

  meta = {
    description = "Torrent client";
    homepage = "https://deluge-torrent.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ a-peirogon ];
    platforms = lib.platforms.all;
  };
})
