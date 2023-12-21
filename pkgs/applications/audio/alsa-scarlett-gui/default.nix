{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, makeWrapper
, alsa-utils
, alsa-lib
, gtk4
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "alsa-scarlett-gui";
  version = "unstable-2022-08-11";

  src = fetchFromGitHub {
    owner = "geoffreybennett";
    repo = pname;
    rev = "65c0f6aa432501355803a823be1d3f8aafe907a8";
    sha256 = "sha256-wzBOPTs8PTHzu5RpKwKhx552E7QnDx2Zn4OFaes8Q2I=";
  };

  NIX_CFLAGS_COMPILE = [ "-Wno-error=deprecated-declarations" ];

  makeFlags = [ "DESTDIR=\${out}" "PREFIX=''" ];
  sourceRoot = "${src.name}/src";
  nativeBuildInputs = [ pkg-config wrapGAppsHook4 makeWrapper ];
  buildInputs = [ gtk4 alsa-lib ];
  postInstall = ''
    wrapProgram $out/bin/alsa-scarlett-gui --prefix PATH : ${lib.makeBinPath [ alsa-utils ]}

    substituteInPlace $out/share/applications/vu.b4.alsa-scarlett-gui.desktop \
      --replace "Exec=/bin/alsa-scarlett-gui" "Exec=$out/bin/alsa-scarlett-gui"
  '';

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  meta = with lib; {
    description = "GUI for alsa controls presented by Focusrite Scarlett Gen 2/3 Mixer Driver";
    homepage = "https://github.com/geoffreybennett/alsa-scarlett-gui";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sebtm ];
    platforms = platforms.linux;
  };
}
