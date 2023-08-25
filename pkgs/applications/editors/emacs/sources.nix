{ lib
, fetchFromBitbucket
, fetchFromSavannah
}:

let
  metaFor = variant: version: rev: {
    homepage = {
      "mainline" = "https://www.gnu.org/software/emacs/";
      "macport" = "https://bitbucket.org/mituharu/emacs-mac/";
    }.${variant};
    description = "The extensible, customizable GNU text editor"
                  + lib.optionalString (variant == "macport") " - macport variant";
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
    '' + lib.optionalString (variant == "macport") ''

      This release is built from Mitsuharu Yamamoto's patched source code
      tailored for macOS.
    '';
    changelog = {
      "mainline" = "https://www.gnu.org/savannah-checkouts/gnu/emacs/news/NEWS.${version}";
      "macport" = "https://bitbucket.org/mituharu/emacs-mac/raw/${rev}/NEWS-mac";
    }.${variant};
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      AndersonTorres
      adisbladis
      atemu
      jwiegley
      lovek323
      matthewbauer
    ];
    platforms = {
      "mainline" = lib.platforms.all;
      "macport" = lib.platforms.darwin;
    }.${variant};
    mainProgram = "emacs";
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

    meta = metaFor "mainline" "28.2" "28.2";
  };

  emacs29 = import ./generic.nix {
    pname = "emacs";
    version = "29.1";
    variant = "mainline";
    src = fetchFromSavannah {
      repo = "emacs";
      rev = "29.1";
      hash = "sha256-3HDCwtOKvkXwSULf3W7YgTz4GV8zvYnh2RrL28qzGKg=";
    };

    meta = metaFor "mainline" "29.1" "29.1";
  };

  emacs28-macport = import ./generic.nix {
    pname = "emacs-mac";
    version = "28.2";
    variant = "macport";
    src = fetchFromBitbucket {
      owner = "mituharu";
      repo = "emacs-mac";
      rev = "emacs-28.2-mac-9.1";
      hash = "sha256-Ne2jQ2nVLNiQmnkkOXVc5AkLVkTpm8pFC7VNY2gQjPE=";
    };

    meta = metaFor "macport" "28.2" "emacs-28.2-mac-9.1";
  };

  emacs29-macport = import ./generic.nix {
    pname = "emacs-mac";
    version = "29.1";
    variant = "macport";

    src = fetchFromBitbucket {
      owner = "mituharu";
      repo = "emacs-mac";
      rev = "emacs-29.1-mac-10.0";
      hash = "sha256-TE829qJdPjeOQ+kD0SfyO8d5YpJjBge/g+nScwj+XVU=";
    };

    meta = metaFor "macport" "29.1" "emacs-29.1-mac-10.0";
  };
}
