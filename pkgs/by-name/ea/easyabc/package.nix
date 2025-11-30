{
  lib,
  fetchFromGitHub,
  replaceVars,
  python3,
  fluidsynth,
  soundfont-fluid,
  wrapGAppsHook3,
  abcmidi,
  abcm2ps,
  ghostscript,
}:

python3.pkgs.buildPythonApplication {
  pname = "easyabc";
  version = "1.3.8.7-unstable-2025-01-12";
  format = "other";

  src = fetchFromGitHub {
    owner = "jwdj";
    repo = "easyabc";
    rev = "2cfa74d138d485523cae9b889186add3a249f2e4";
    hash = "sha256-96Rh7hFWITIC62vs0bUtatDDgJ27UdZYhku8uqJBJew=";
  };

  patches = [
    (replaceVars ./hardcoded-paths.patch {
      fluidsynth = "${fluidsynth}/lib/libfluidsynth.so";
      soundfont = "${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2";
      ghostscript = "${ghostscript}/bin/gs";
    })
  ];

  nativeBuildInputs = [ wrapGAppsHook3 ];

  dependencies = with python3.pkgs; [
    cx-freeze
    wxpython
    pygame
    pyparsing
  ];

  # apparently setup.py only supports Windows and Darwin
  # everything is very non-standard in this project
  dontBuild = true;

  # https://discourse.nixos.org/t/packaging-mcomix3-python-gtk-missing-gsettings-schemas-issue/10190/2
  strictDeps = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/easyabc
    mv * $out/share/easyabc

    ln -s ${abcmidi}/bin/abc2midi $out/share/easyabc/bin/abc2midi
    ln -s ${abcmidi}/bin/midi2abc $out/share/easyabc/bin/midi2abc
    ln -s ${abcmidi}/bin/abc2abc $out/share/easyabc/bin/abc2abc
    ln -s ${abcm2ps}/bin/abcm2ps $out/share/easyabc/bin/abcm2ps

    makeWrapper ${python3.interpreter} $out/bin/easyabc \
      --set PYTHONPATH "$PYTHONPATH:$out/share/easyabc" \
      --add-flags "-O $out/share/easyabc/easy_abc.py"

    runHook postInstall
  '';

  meta = {
    description = "ABC music notation editor";
    mainProgram = "easyabc";
    homepage = "https://easyabc.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mausch ];
  };
}
