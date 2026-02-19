{
  stdenv,
  gtk3,
  libadwaita,
  glib,
  gobject-introspection,
  pkg-config,
  fetchFromGitea,
}:

stdenv.mkDerivation {
  pname = "gtk-nocsd";
  # No real version using current commit as version.
  version = "1.5.0";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "MorsMortium";
    repo = "GTK-NoCSD";
    rev = "807bcbfc19e7970d0e842e99e444ce55a87b3b85";
    hash = "sha256-5pCDNmN9i+5tsfx2n7WrgNyXA2lGYLuU0ZlsVv/yZ7E=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gtk3
    libadwaita
    glib
    gobject-introspection
  ];
  buildPhase = ''
    runHook preBuild
    gcc -fPIC -shared ./Source/GTK-NoCSD.c -o libgtk-nocsd.so.0 -Wl,-soname,libgtk-nocsd.so.0 $(pkg-config --cflags libadwaita-1) $(pkg-config --cflags --libs gobject-2.0 gio-2.0)
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib
    cp libgtk-nocsd.so.0 $out/lib/
      runHook postInstall
  '';
}
