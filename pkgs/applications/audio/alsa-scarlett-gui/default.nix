{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, makeWrapper
, alsa-utils
, alsa-lib
, gtk4
, openssl
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "alsa-scarlett-gui";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "geoffreybennett";
    repo = "alsa-scarlett-gui";
    rev = version;
    hash = "sha256-+74JRQn2xwgPHZSrp5b+uny0+aLnsFvx/cOKIdj4J40=";
  };

  NIX_CFLAGS_COMPILE = [ "-Wno-error=deprecated-declarations" ];

  makeFlags = [ "DESTDIR=\${out}" "PREFIX=''" ];
  sourceRoot = "${src.name}/src";

  postPatch = ''
    substituteInPlace file.c \
      --replace-fail "/usr/sbin/alsactl" "${alsa-utils}/bin/alsactl"
  '';

  nativeBuildInputs = [ pkg-config wrapGAppsHook4 makeWrapper ];
  buildInputs = [ gtk4 alsa-lib openssl ];
  postInstall = ''
    wrapProgram $out/bin/alsa-scarlett-gui --prefix PATH : ${lib.makeBinPath [ alsa-utils ]}

    substituteInPlace $out/share/applications/vu.b4.alsa-scarlett-gui.desktop \
      --replace-fail "Exec=/bin/alsa-scarlett-gui" "Exec=$out/bin/alsa-scarlett-gui"
  '';

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  meta = with lib; {
    description = "GUI for alsa controls presented by Focusrite Scarlett Gen 2/3/4 Mixer Driver";
    mainProgram = "alsa-scarlett-gui";
    homepage = "https://github.com/geoffreybennett/alsa-scarlett-gui";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mdorman ];
    platforms = platforms.linux;
  };
}
