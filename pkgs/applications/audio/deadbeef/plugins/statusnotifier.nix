{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  deadbeef,
  gtk3,
  perl,
  libdbusmenu,
}:

stdenv.mkDerivation rec {
  pname = "deadbeef-statusnotifier-plugin";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "vovochka404";
    repo = "deadbeef-statusnotifier-plugin";
    rev = "v${version}";
    sha256 = "sha256-6WEbY59vPNrL3W5GUwFQJimmSS+td8Ob+G46fPAxfV4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    deadbeef
    gtk3
    libdbusmenu
  ];

  buildFlags = [ "gtk3" ];

  postPatch = ''
    substituteInPlace tools/glib-mkenums \
      --replace /usr/bin/perl "${perl}/bin/perl"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/deadbeef
    cp build/sni_gtk3.so $out/lib/deadbeef
    runHook postInstall
  '';

  meta = with lib; {
    description = "DeaDBeeF StatusNotifier Plugin";
    homepage = "https://github.com/vovochka404/deadbeef-statusnotifier-plugin";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.kurnevsky ];
    platforms = platforms.linux;
  };
}
