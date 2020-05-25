{ stdenv, fetchFromGitLab, meson, ninja, cmake
, wrapGAppsHook, pkgconfig, desktop-file-utils
, appstream-glib, pythonPackages, glib, gobject-introspection
, gtk3, webkitgtk, glib-networking, gnome3, gspell, texlive
, shared-mime-info, haskellPackages}:

let
  pythonEnv = pythonPackages.python.withPackages(p: with p;
    [ regex setuptools python-Levenshtein pyenchant pygobject3 pycairo pypandoc ]);
  texliveDist = texlive.combined.scheme-medium;

in stdenv.mkDerivation rec {
  pname = "apostrophe";
  version = "unstable-2020-03-29";

  src = fetchFromGitLab {
    owner  = "somas";
    repo   = pname;
    domain = "gitlab.gnome.org";
    rev    = "219fa8976e3b8a6f0cea15cfefe4e336423f2bdb";
    sha256 = "192n5qs3x6rx62mqxd6wajwm453pns8kjyz5v3xc891an6bm1kqx";
  };

  nativeBuildInputs = [ meson ninja cmake pkgconfig desktop-file-utils
    appstream-glib wrapGAppsHook ];

  buildInputs = [ glib pythonEnv gobject-introspection gtk3
    gnome3.adwaita-icon-theme webkitgtk gspell texliveDist
    glib-networking ];

  postPatch = ''
    patchShebangs --build build-aux/meson_post_install.py

    substituteInPlace ${pname}/config.py --replace "/usr/share/${pname}" "$out/share/${pname}"

    # get rid of unused distributed dependencies
    rm -r ${pname}/pylocales
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
    homepage = "https://gitlab.gnome.org/somas/apostrophe";
    description = "A distraction free Markdown editor for GNU/Linux";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.sternenseemann ];
  };
}
