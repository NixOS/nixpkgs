{ stdenv, fetchurl, gettext, pkgconfig, ruby
, boost, expat, file, flac, libebml, libmatroska, libogg, libvorbis, xdg_utils, zlib
# pugixml (not packaged)
, buildConfig ? "all"
, withGUI ? false, qt5 ? null # Disabled for now until upstream issues are resolved
, legacyGUI ? true, wxGTK ? null
# For now both qt5 and wxwidgets gui's are enabled, if wxwidgets is disabled the
# build system doesn't install desktop entries, icons, etc...
, libiconv
}:

let
  inherit (stdenv.lib) enableFeature optional;
in

assert withGUI -> qt5 != null;
assert legacyGUI -> wxGTK != null;

stdenv.mkDerivation rec {
  name = "mkvtoolnix-${version}";
  version = "8.4.0";

  src = fetchurl {
    url = "http://www.bunkus.org/videotools/mkvtoolnix/sources/${name}.tar.xz";
    sha256 = "0y7qm8q9vpvjiw7b69k9140pw9nhvs6ggmk56yxnmcd02inm19gn";
  };

  patchPhase = ''
    patchShebangs ./rake.d/
    patchShebangs ./Rakefile
    # Force ruby encoding to use UTF-8 or else when enabling qt5 the Rakefile may
    # fail with `invalid byte sequence in US-ASCII' due to UTF-8 characters
    # This workaround replaces an arbitrary comment in the drake file
    sed -e 's,#--,Encoding.default_external = Encoding::UTF_8,' -i ./drake
  '';

  configureFlags = [
    "--with-boost-libdir=${boost.lib}/lib"
    "--without-curl"
  ] ++ (
    if (withGUI || legacyGUI) then [
      "--with-mkvtoolnix-gui"
      "--enable-gui"
      (enableFeature withGUI "qt")
      (enableFeature legacyGUI "wxwidgets")
    ] else [
      "--disable-gui"
    ]
  );

  nativeBuildInputs = [ gettext pkgconfig ruby ];

  buildInputs = [
    boost expat file flac libebml libmatroska libogg libvorbis xdg_utils zlib
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv ]
    ++ optional withGUI qt5
    ++ optional legacyGUI wxGTK;

  enableParallelBuilding = true;

  buildPhase = ''
    ./drake
  '';

  installPhase = ''
    ./drake install
  '';

  meta = with stdenv.lib; {
    description = "Cross-platform tools for Matroska";
    homepage = http://www.bunkus.org/videotools/mkvtoolnix/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ codyopel fuuzetsu ];
    platforms = platforms.all;
  };
}
