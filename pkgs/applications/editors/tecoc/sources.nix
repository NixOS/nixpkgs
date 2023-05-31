{ lib
, fetchFromGitHub
, unstableGitUpdater
}:

{
  tecoc-unstable = import ./generic.nix {
    pname = "tecoc";
    version = "unstable-2023-04-21";

    src = fetchFromGitHub {
      owner = "blakemcbride";
      repo = "TECOC";
      rev = "021d1d15242b9d6c84d70c9ffcf1871793898f0a";
      hash = "sha256-VGIO+uiAZkdzLYmJztmnKTS4HDIVow4AimaneHj7E1M=";
    };

    passthru.updateScript = unstableGitUpdater {
      url = "https://github.com/blakemcbride/TECOC";
    };

    meta = {
      homepage = "https://github.com/blakemcbride/TECOC";
      description = "A clone of the good old TECO editor";
      longDescription = ''
        For those who don't know: TECO is the acronym of Tape Editor and COrrector
        (because it was a paper tape edition tool in its debut days). Now the
        acronym follows after Text Editor and Corrector, or Text Editor
        Character-Oriented.

        TECO is a character-oriented text editor, originally developed by Dan
        Murphy at MIT circa 1962. It is also a Turing-complete imperative
        interpreted programming language for text manipulation, done via
        user-loaded sets of macros. In fact, the venerable Emacs was born as a set
        of Editor MACroS for TECO.

        TECOC is a portable C implementation of TECO-11.
      '';
      license = {
        url = "https://github.com/blakemcbride/TECOC/tree/master/doc/readme-1st.txt";
      };
      maintainers = [ lib.maintainers.AndersonTorres ];
      platforms = lib.platforms.unix;
    };
  };
}
