{ lib
, fetchFromBitbucket
, fetchFromSavannah
}:

let
  mainlineMeta = {
    homepage = "https://www.gnu.org/software/emacs/";
    description = "The extensible, customizable GNU text editor";
    longDescription = ''
      GNU Emacs is an extensible, customizable text editor—and more. At its core
      is an interpreter for Emacs Lisp, a dialect of the Lisp programming
      language with extensions to support text editing.

      The features of GNU Emacs include: content-sensitive editing modes,
      including syntax coloring, for a wide variety of file types including
      plain text, source code, and HTML; complete built-in documentation,
      including a tutorial for new users; full Unicode support for nearly all
      human languages and their scripts; highly customizable, using Emacs Lisp
      code or a graphical interface; a large number of extensions that add other
      functionality, including a project planner, mail and news reader, debugger
      interface, calendar, and more. Many of these extensions are distributed
      with GNU Emacs; others are available separately.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      AndersonTorres
      adisbladis
      atemu
      jwiegley
      lovek323
      matthewbauer
    ];
    platforms = lib.platforms.all;
  };
in
{
  emacs28 = import ./generic.nix {
    pname = "emacs";
    version = "28.2";
    variant = "mainline";
    src = fetchFromSavannah {
      repo = "emacs";
      rev = "28.2";
      hash = "sha256-4oSLcUDR0MOEt53QOiZSVU8kPJ67GwugmBxdX3F15Ag=";
    };

    meta = mainlineMeta;
  };

  emacs29 = import ./generic.nix {
    pname = "emacs";
    version = "29.0.92";
    variant = "mainline";
    src = fetchFromSavannah {
      repo = "emacs";
      rev = "29.0.92";
      hash = "sha256-Vkry+2zYejZVwZKQlmQiAJnbjsj87DiIZ1ungooYd8A=";
    };

    meta = mainlineMeta;
  };

  emacs-macport = import ./generic.nix {
    pname = "emacs-mac";
    version = "28.2";
    variant = "macport";
    src = fetchFromBitbucket {
      owner = "mituharu";
      repo = "emacs-mac";
      rev = "emacs-28.2-mac-9.1";
      hash = "sha256-Ne2jQ2nVLNiQmnkkOXVc5AkLVkTpm8pFC7VNY2gQjPE=";
    };

    meta = {
      homepage = "https://bitbucket.org/mituharu/emacs-mac/";
      description = mainlineMeta.description + " - with macport patches";
      longDescription = mainlineMeta.longDescription + ''

        This release is built from Mitsuharu Yamamoto's patched source code
        tailoired for MacOS X.
      '';
      inherit (mainlineMeta) license maintainers;
      platforms = lib.platforms.darwin;
    };
  };
}
