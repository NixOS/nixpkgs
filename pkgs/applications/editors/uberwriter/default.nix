{ stdenv, fetchFromGitHub, meson, ninja, cmake
, wrapGAppsHook, pkgconfig, desktop-file-utils
, appstream-glib, pythonPackages, glib, gobject-introspection
, gtk3, webkitgtk, glib-networking, gnome3, gspell, texlive
, shared-mime-info, haskellPackages}:

let
  pythonEnv = pythonPackages.python.withPackages(p: with p;
    [ regex setuptools python-Levenshtein pyenchant pygobject3 pycairo pypandoc ]);
  texliveDist = texlive.combined.scheme-medium;

in stdenv.mkDerivation rec {
  pname = "uberwriter";
  version = "unstable-2020-01-24";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "0647b413407eb8789a25c353602c4ac979dc342a";
    sha256 = "19z52fpbf0p7dzx7q0r5pk3nn0c8z69g1hv6db0cqp61cqv5z95q";
  };

  nativeBuildInputs = [ meson ninja cmake pkgconfig desktop-file-utils
    appstream-glib wrapGAppsHook ];

  buildInputs = [ glib pythonEnv gobject-introspection gtk3
    gnome3.adwaita-icon-theme webkitgtk gspell texliveDist
    glib-networking ];

  postPatch = ''
    patchShebangs --build build-aux/meson_post_install.py

    substituteInPlace uberwriter/config.py --replace "/usr/share/uberwriter" "$out/share/uberwriter"

    # get rid of unused distributed dependencies
    rm -r uberwriter/{pylocales,pressagio}
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$out/lib/python${pythonEnv.pythonVersion}/site-packages/"
      --prefix PATH : "${texliveDist}/bin"
      --prefix PATH : "${haskellPackages.pandoc-citeproc}/bin"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  meta = with stdenv.lib; {
    homepage = http://uberwriter.github.io/uberwriter/;
    description = "A distraction free Markdown editor for GNU/Linux";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.sternenseemann ];
  };
}
