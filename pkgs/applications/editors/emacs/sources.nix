{
  lib,
  fetchFromGitHub,
  fetchzip,
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
      meta ? { },
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
            fetchzip {
              url = "mirror://gnu/emacs/${rev}.tar.xz";
              inherit hash;
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
        ''
        + lib.optionalString (variant == "macport") ''

          This release initially was built from Mitsuharu Yamamoto's patched source code
          tailored for macOS. Moved to a fork of the latter starting with emacs v30 as the
          original project seems to be currently dormant.
        '';
        changelog =
          {
            "mainline" = "https://www.gnu.org/savannah-checkouts/gnu/emacs/news/NEWS.${version}";
            "macport" = "https://github.com/jdtsmith/emacs-mac/blob/${rev}/NEWS-mac";
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
            "macport" = with lib.maintainers; [
              kfiz
            ];
          }
          .${variant};
        platforms =
          {
            "mainline" = lib.platforms.all;
            "macport" = lib.platforms.darwin;
          }
          .${variant};
        mainProgram = "emacs";
      }
      // meta;
    };
in
{
  emacs30 = import ./make-emacs.nix (mkArgs {
    pname = "emacs";
    version = "30.2";
    variant = "mainline";
    rev = "emacs-30.2";
    hash = "sha256-W2eZ+cNQhi/fMeRkwOqSKU7Vzvp43WUOpiwaLLNEXtg=";
    patches = fetchpatch: [
      (builtins.path {
        name = "inhibit-lexical-cookie-warning-67916.patch";
        path = ./inhibit-lexical-cookie-warning-67916-30.patch;
      })
    ];
  });

  emacs30-macport = import ./make-emacs.nix (mkArgs {
    pname = "emacs-mac";
    version = "30.2.50";
    variant = "macport";
    rev = "emacs-mac-30.2";
    hash = "sha256-i/W2Xa6Vk1+T1fs6fa4wJVMLLB6BK8QAPcdmPrU8NwM=";
  });
}
