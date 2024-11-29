{ lib, fetchFromGitHub, fetchPypi, substituteAll, python39, fluidsynth, soundfont-fluid, wrapGAppsHook3, abcmidi, abcm2ps, ghostscript }:

let
  # requires python39 due to https://stackoverflow.com/a/71902541 https://github.com/jwdj/EasyABC/issues/52
  python = python39.override {
    self = python;
    packageOverrides = self: super: {
      # currently broken with 4.2.1
      # https://github.com/jwdj/EasyABC/issues/75
      wxpython = super.wxpython.overrideAttrs (args: rec {
        version = "4.2.0";
        src = fetchPypi {
          inherit version;
          pname = "wxPython";
          hash = "sha256-ZjzrxFCdfl0RNRiGX+J093+VQ0xdV7w4btWNZc7thsc=";
        };
      });
    };
  };
in python.pkgs.buildPythonApplication {
  pname = "easyabc";
  version = "1.3.8.6";

  src = fetchFromGitHub {
    owner = "jwdj";
    repo = "easyabc";
    rev = "6461b2c14280cb64224fc5299c31cfeef9b7d43c";
    hash = "sha256-leC3A4HQMeJNeZXArb3YAYr2mddGPcws618NrRh2Q1Y=";
  };

  nativeBuildInputs = [ wrapGAppsHook3 ];

  propagatedBuildInputs = with python.pkgs; [
    cx-freeze
    wxpython
    pygame
  ];

  # apparently setup.py only supports Windows and Darwin
  # everything is very non-standard in this project
  dontBuild = true;
  format = "other";

  # https://discourse.nixos.org/t/packaging-mcomix3-python-gtk-missing-gsettings-schemas-issue/10190/2
  strictDeps = false;

  patches = [
    (substituteAll {
      src = ./hardcoded-paths.patch;
      fluidsynth = "${fluidsynth}/lib/libfluidsynth.so";
      soundfont = "${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2";
      ghostscript = "${ghostscript}/bin/gs";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/easyabc
    mv * $out/share/easyabc

    ln -s ${abcmidi}/bin/abc2midi $out/share/easyabc/bin/abc2midi
    ln -s ${abcmidi}/bin/midi2abc $out/share/easyabc/bin/midi2abc
    ln -s ${abcmidi}/bin/abc2abc $out/share/easyabc/bin/abc2abc
    ln -s ${abcm2ps}/bin/abcm2ps $out/share/easyabc/bin/abcm2ps

    makeWrapper ${python.interpreter} $out/bin/easyabc \
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
