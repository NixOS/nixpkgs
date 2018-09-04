{ stdenv, fetchFromGitHub, fetchpatch, gnome3, meson, ninja, gettext, pkgconfig, libxml2, gtk3, hicolor-icon-theme, wrapGAppsHook }:

let
  version = "2.3";
in stdenv.mkDerivation {
  name = "gcolor3-${version}";

  src = fetchFromGitHub {
    owner = "hjdskes";
    repo = "gcolor3";
    rev = "v${version}";
    sha256 = "186j72kwsqdcakvdik9jl18gz3csdj53j3ylwagr9gfwmy0nmyjb";
  };

  patches = [
    # Fix darwin build
    (fetchpatch {
      url = https://github.com/Hjdskes/gcolor3/commit/9130ffeff091fbafff6a0c8f06b09f54657d5dfd.patch;
      sha256 = "1kn5hx536wivafb4awg7lsa8h32njy0lynmn7ci9y78dlp54057r";
    })
    (fetchpatch {
      url = https://github.com/Hjdskes/gcolor3/commit/8d89081a8e13749f5a9051821114bc5fe814eaf3.patch;
      sha256 = "1ldyr84dl2g6anqkp2mpxsrcr41fcqwi6ck14rfhai7rgrm8yar3";
    })
  ];

  nativeBuildInputs = [ meson ninja gettext pkgconfig libxml2 wrapGAppsHook ];

  buildInputs = [ gtk3 hicolor-icon-theme ];

  postPatch = ''
    chmod +x meson_install.sh # patchShebangs requires executable file
    patchShebangs meson_install.sh
  '';

  meta = with stdenv.lib; {
    description = "A simple color chooser written in GTK3";
    homepage = https://hjdskes.github.io/projects/gcolor3/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
