{
  lib,
  fetchFromBitbucket,
  fetchFromGitHub,
  fetchFromSavannah,
}:

let
  mkArgs =
    {
      pname,
      version,
      variant,
      patches ? _: [ ],
      rev,
      hash,
    }:
    {
      inherit
        pname
        version
        variant
        patches
        ;

      src =
        {
          "mainline" = (
            fetchFromSavannah {
              repo = "emacs";
              inherit rev hash;
            }
          );
          "macport" = (
            fetchFromGitHub {
              owner = "jdtsmith";
              repo = "emacs-mac";
              inherit rev hash;
            }
          );
        }
        .${variant};

      meta = {
        homepage =
          {
            "mainline" = "https://www.gnu.org/software/emacs/";
            "macport" = "https://bitbucket.org/mituharu/emacs-mac/";
          }
          .${variant};
        description =
          "Extensible, customizable GNU text editor"
          + lib.optionalString (variant == "macport") " - macport variant";
        longDescription =
          ''
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
          ''
          + lib.optionalString (variant == "macport") ''

            This release is built from Mitsuharu Yamamoto's patched source code
            tailored for macOS.
          '';
        changelog =
          {
            "mainline" = "https://www.gnu.org/savannah-checkouts/gnu/emacs/news/NEWS.${version}";
            "macport" = "https://bitbucket.org/mituharu/emacs-mac/raw/${rev}/NEWS-mac";
          }
          .${variant};
        license = lib.licenses.gpl3Plus;
        maintainers =
          {
            "mainline" = with lib.maintainers; [
              AndersonTorres
              adisbladis
              jwiegley
              lovek323
              matthewbauer
              panchoh
            ];
            "macport" = with lib.maintainers; [ ];
          }
          .${variant};
        platforms =
          {
            "mainline" = lib.platforms.all;
            "macport" = lib.platforms.darwin;
          }
          .${variant};
        mainProgram = "emacs";
      };
    };
in
{
  emacs30 = import ./make-emacs.nix (mkArgs {
    pname = "emacs";
    version = "30.1";
    variant = "mainline";
    rev = "30.1";
    hash = "sha256-wBuWLuFzwB77FqAYAUuNe3CuJFutjqp0XGt5srt7jAo=";
    patches = fetchpatch: [
      (builtins.path {
        name = "inhibit-lexical-cookie-warning-67916.patch";
        path = ./inhibit-lexical-cookie-warning-67916-30.patch;
      })
      (fetchpatch {
        # bug#63288 and bug#76523
        url = "https://git.savannah.gnu.org/cgit/emacs.git/patch/?id=53a5dada413662389a17c551a00d215e51f5049f";
        hash = "sha256-AEvsQfpdR18z6VroJkWoC3sBoApIYQQgeF/P2DprPQ8=";
      })
    ];
  });

  emacs30-macport = import ./make-emacs.nix (mkArgs {
    pname = "emacs-mac";
    version = "30.1.50";
    variant = "macport";
    rev = "a50f20585960d92510fb62c95cb12606218a2081";
    hash = "sha256-Ap4ZBb9NYIbwLroOoqvpQU/hjhaJJDB+3/1V0Q2c6aA=";
    patches = _: [ ./macport-stdbool.patch ];
  });
}
