{ lib, fetchFromGitHub, stdenv
, ffmpeg, frei0r, sox, gtk3, python3, ladspaPlugins
, gobject-introspection, makeWrapper, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "flowblade";
<<<<<<< HEAD
  version = "2.10.0.4";
=======
  version = "2.8.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jliljebl";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-IjutDCp+wrvXSQzvELuPMdW/16Twi0ee8VjdAFyi+OE=";
  };

  buildInputs = [
    ffmpeg frei0r sox gtk3 ladspaPlugins
=======
    sha256 = "sha256-/EkI3qiceB5eKTVQnpG+z4e6yaE9hDtn6I+iN/J+h/g=";
  };

  buildInputs = [
    ffmpeg frei0r sox gtk3 gobject-introspection ladspaPlugins
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      --prefix PATH : "${lib.makeBinPath [ ffmpeg ]}" \
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
