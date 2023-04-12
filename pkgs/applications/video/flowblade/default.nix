{ lib, fetchFromGitHub, stdenv
, ffmpeg, frei0r, sox, gtk3, python3, ladspaPlugins
, gobject-introspection, makeWrapper, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "flowblade";
  version = "2.8.0.3";

  src = fetchFromGitHub {
    owner = "jliljebl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/EkI3qiceB5eKTVQnpG+z4e6yaE9hDtn6I+iN/J+h/g=";
  };

  buildInputs = [
    ffmpeg frei0r sox gtk3 gobject-introspection ladspaPlugins
    (python3.withPackages (ps: with ps; [ mlt pygobject3 dbus-python numpy pillow ]))
  ];

  nativeBuildInputs = [ gobject-introspection makeWrapper wrapGAppsHook ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -a ${src}/flowblade-trunk $out/flowblade

    makeWrapper $out/flowblade/flowblade $out/bin/flowblade \
      --set FREI0R_PATH ${frei0r}/lib/frei0r-1 \
      --set LADSPA_PATH ${ladspaPlugins}/lib/ladspa \
      ''${gappsWrapperArgs[@]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Multitrack Non-Linear Video Editor";
    homepage = "https://jliljebl.github.io/flowblade/";
    license = with licenses; [ gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ polygon ];
  };
}
