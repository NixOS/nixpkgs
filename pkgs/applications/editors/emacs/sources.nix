{ lib
, fetchFromBitbucket
, fetchFromSavannah
}:

let
  mkArgs = { pname, version, variant, rev, hash }: {
    inherit pname version variant;

    src = {
      "mainline" = (fetchFromSavannah {
        repo = "emacs";
        inherit rev hash;
      });
      "macport" = (fetchFromBitbucket {
        owner = "mituharu";
        repo = "emacs-mac";
        inherit rev hash;
      });
    }.${variant};

    meta = {
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
  };
in
{
  emacs28 = import ./make-emacs.nix (mkArgs {
    pname = "emacs";
    version = "28.2";
    variant = "mainline";
    rev = "28.2";
    hash = "sha256-4oSLcUDR0MOEt53QOiZSVU8kPJ67GwugmBxdX3F15Ag=";
  });

  emacs29 = import ./make-emacs.nix (mkArgs {
    pname = "emacs";
    version = "29.1";
    variant = "mainline";
    rev = "29.1";
    hash = "sha256-3HDCwtOKvkXwSULf3W7YgTz4GV8zvYnh2RrL28qzGKg=";
  });

  emacs28-macport = import ./make-emacs.nix (mkArgs {
    pname = "emacs-mac";
    version = "28.2";
    variant = "macport";
    rev = "emacs-28.2-mac-9.1";
    hash = "sha256-Ne2jQ2nVLNiQmnkkOXVc5AkLVkTpm8pFC7VNY2gQjPE=";
  });

  emacs29-macport = import ./make-emacs.nix (mkArgs {
    pname = "emacs-mac";
    version = "29.1";
    variant = "macport";
    rev = "emacs-29.1-mac-10.0";
    hash = "sha256-TE829qJdPjeOQ+kD0SfyO8d5YpJjBge/g+nScwj+XVU=";
  });
}
