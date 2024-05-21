{ lib
, fetchurl
}:

let
  meta = {
    description = "The GNU implementation of the standard Unix editor";
    longDescription = ''
      GNU ed is a line-oriented text editor. It is used to create, display,
      modify and otherwise manipulate text files, both interactively and via
      shell scripts. A restricted version of ed, red, can only edit files in the
      current directory and cannot execute shell commands. Ed is the 'standard'
      text editor in the sense that it is the original editor for Unix, and thus
      widely available. For most purposes, however, it is superseded by
      full-screen editors such as GNU Emacs or GNU Moe.
    '';
    license = lib.licenses.gpl3Plus;
    homepage = "https://www.gnu.org/software/ed/";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
in
{
  ed = let
    pname = "ed";
    version = "1.20.2";
    src = fetchurl {
      url = "mirror://gnu/ed/ed-${version}.tar.lz";
      hash = "sha256-Zf7HMY9IwsoX8zSsD0cD3v5iA3uxPMI5IN4He1+iRSM=";
    };
  in import ./generic.nix {
    inherit pname version src meta;
  };

  edUnstable = let
    pname = "ed";
    version = "1.20-pre2";
    src = fetchurl {
      url = "http://download.savannah.gnu.org/releases/ed/ed-${version}.tar.lz";
      hash = "sha256-bHTDeMhVNNo3qqDNoBNaBA+DHDa4WJpfQNcTvAUPgsY=";
    };
  in import ./generic.nix {
    inherit pname version src meta;
  };
}
