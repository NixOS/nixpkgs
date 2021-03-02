{ lib, stdenv, fetchFromGitLab, meson, ninja, cmake
, wrapGAppsHook, pkg-config, desktop-file-utils
, appstream-glib, pythonPackages, glib, gobject-introspection
, gtk3, webkitgtk, glib-networking, gnome3, gspell, texlive
, shared-mime-info, haskellPackages, libhandy
}:

let
  pythonEnv = pythonPackages.python.withPackages(p: with p; [
    regex setuptools python-Levenshtein pyenchant
    pygobject3 pycairo pypandoc chardet
  ]);

in stdenv.mkDerivation rec {
  pname = "apostrophe";
  version = "2.3";

  src = fetchFromGitLab {
    owner  = "somas";
    repo   = pname;
    domain = "gitlab.gnome.org";
    rev    = "v${version}";
    sha256 = "1ggrbbnhbnf6p3hs72dww3c9m1rvr4znggmvwcpj6i8v1a3kycnb";
  };

  nativeBuildInputs = [ meson ninja cmake pkg-config desktop-file-utils
    appstream-glib wrapGAppsHook ];

  buildInputs = [ glib pythonEnv gobject-introspection gtk3
    gnome3.adwaita-icon-theme webkitgtk gspell texlive
    glib-networking libhandy ];

  postPatch = ''
    patchShebangs --build build-aux/meson_post_install.py

    # get rid of unused distributed dependencies
    rm -r ${pname}/pylocales
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$out/lib/python${pythonEnv.pythonVersion}/site-packages/"
      --prefix PATH : "${texlive}/bin"
      --prefix PATH : "${haskellPackages.pandoc-citeproc}/bin"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/somas/apostrophe";
    description = "A distraction free Markdown editor for GNU/Linux";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.sternenseemann ];
  };
}
