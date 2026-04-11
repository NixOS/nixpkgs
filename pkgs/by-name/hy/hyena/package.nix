{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  mono,
  gtk-sharp-2_0,
  monoDLLFixer,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyena";
  version = "0.5";

  src = fetchurl {
    url = "mirror://gnome/sources/hyena/${lib.versions.majorMinor finalAttrs.version}/hyena-${finalAttrs.version}.tar.bz2";
    sha256 = "eb7154a42b6529bb9746c39272719f3168d6363ed4bad305a916ed7d90bc8de9";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    mono
    gtk-sharp-2_0
  ];

  postPatch = ''
    patchShebangs build/dll-map-makefile-verifier
    patchShebangs build/private-icon-theme-installer
    substituteInPlace configure --replace lib/mono/2.0/ lib/mono/2.0-api/
    find -name Makefile.in | xargs -n 1 -d '\n' sed -e 's/^dnl/#/' -i
  '';

  dontStrip = true;

  inherit monoDLLFixer;

  meta = {
    homepage = "https://gitlab.gnome.org/Archive/hyena";
    description = "C# library which contains a hodge-podge of random stuff";
    longDescription = ''
      Hyena is a C# library used to make awesome applications. It contains a lot of random things,
      including useful data structures, a Sqlite-based db layer, cool widgets, a JSON library,
      a smart job/task scheduler, a user-query/search parser, and much more. It's particularly
      useful for Gtk# applications, though only the Hyena.Gui assembly requires Gtk#.
    '';
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ obadz ];
    license = lib.licenses.mit;
  };
})
