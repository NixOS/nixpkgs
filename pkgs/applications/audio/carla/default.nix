{ lib, stdenv, fetchFromGitHub, alsaLib, file, fluidsynth, jack2,
  liblo, libpulseaudio, libsndfile, pkg-config, python3Packages,
  which, withFrontend ? true,
  withQt ? true, qtbase ? null, wrapQtAppsHook ? null,
  withGtk2 ? true, gtk2 ? null,
  withGtk3 ? true, gtk3 ? null }:

with lib;

assert withFrontend -> python3Packages ? pyqt5;
assert withQt -> qtbase != null;
assert withQt -> wrapQtAppsHook != null;
assert withGtk2 -> gtk2 != null;
assert withGtk3 -> gtk3 != null;

stdenv.mkDerivation rec {
  pname = "carla";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "falkTX";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-724EFBpbmPMuU1m3T0XMaeohURJA5JcxHfUPYbZ/2LE=";
  };

  nativeBuildInputs = [
    python3Packages.wrapPython pkg-config which wrapQtAppsHook
  ];

  pythonPath = with python3Packages; [
    rdflib pyliblo
  ] ++ optional withFrontend pyqt5;

  buildInputs = [
    file liblo alsaLib fluidsynth jack2 libpulseaudio libsndfile
  ] ++ optional withQt qtbase
    ++ optional withGtk2 gtk2
    ++ optional withGtk3 gtk3;

  propagatedBuildInputs = pythonPath;

  enableParallelBuilding = true;

  installFlags = [ "PREFIX=$(out)" ];

  dontWrapQtApps = true;
  postFixup = ''
    # Also sets program_PYTHONPATH and program_PATH variables
    wrapPythonPrograms
    wrapPythonProgramsIn "$out/share/carla/resources" "$out $pythonPath"

    find "$out/share/carla" -maxdepth 1 -type f -not -name "*.py" -print0 | while read -d "" f; do
      patchPythonScript "$f"
    done
    patchPythonScript "$out/share/carla/carla_settings.py"
    patchPythonScript "$out/share/carla/carla_database.py"

    for program in $out/bin/*; do
      wrapQtApp "$program" \
        --prefix PATH : "$program_PATH:${which}/bin" \
        --set PYTHONNOUSERSITE true
    done

    find "$out/share/carla/resources" -maxdepth 1 -type f -not -name "*.py" -print0 | while read -d "" f; do
      wrapQtApp "$f" \
        --prefix PATH : "$program_PATH:${which}/bin" \
        --set PYTHONNOUSERSITE true
    done
  '';

  meta = with lib; {
    homepage = "http://kxstudio.sf.net/carla";
    description = "An audio plugin host";
    longDescription = ''
      It currently supports LADSPA (including LRDF), DSSI, LV2, VST2/3
      and AU plugin formats, plus GIG, SF2 and SFZ file support.
      It uses JACK as the default and preferred audio driver but also
      supports native drivers like ALSA, DirectSound or CoreAudio.
    '';
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.minijackson ];
    platforms = platforms.linux;
  };
}
