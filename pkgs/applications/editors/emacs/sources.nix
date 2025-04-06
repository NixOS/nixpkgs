{
  lib,
  fetchFromBitbucket,
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
            fetchFromSavannah {
              repo = "emacs";
              inherit rev hash;
            }
          );
          "macport" = (
            fetchFromBitbucket {
              owner = "mituharu";
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
      } // meta;
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

  emacs28-macport = import ./make-emacs.nix (mkArgs {
    pname = "emacs-mac";
    version = "28.2";
    variant = "macport";
    rev = "emacs-28.2-mac-9.1";
    hash = "sha256-Ne2jQ2nVLNiQmnkkOXVc5AkLVkTpm8pFC7VNY2gQjPE=";
    patches = fetchpatch: [
      # CVE-2022-45939
      (fetchpatch {
        url = "https://git.savannah.gnu.org/cgit/emacs.git/patch/?id=d48bb4874bc6cd3e69c7a15fc3c91cc141025c51";
        hash = "sha256-TiBQkexn/eb6+IqJNDqR/Rn7S7LVdHmL/21A5tGsyJs=";
      })

      # https://lists.gnu.org/archive/html/emacs-devel/2024-03/msg00611.html
      (fetchpatch {
        url = "https://gitweb.gentoo.org/proj/emacs-patches.git/plain/emacs/28.2/10_all_org-macro-eval.patch?id=af40e12cb742510e5d40a06ffc6dfca97e340dd6";
        hash = "sha256-OdGt4e9JGjWJPkfJhbYsmQQc6jart4BH5aIKPIbWKFs=";
      })
      (fetchpatch {
        url = "https://gitweb.gentoo.org/proj/emacs-patches.git/plain/emacs/28.2/11_all_untrusted-content.patch?id=af40e12cb742510e5d40a06ffc6dfca97e340dd6";
        hash = "sha256-wa2bsnCt5yFx0+RAFZGBPI+OoKkbrfkkMer/KBEc/wA=";
      })
      (fetchpatch {
        url = "https://gitweb.gentoo.org/proj/emacs-patches.git/plain/emacs/28.2/12_all_org-remote-unsafe.patch?id=af40e12cb742510e5d40a06ffc6dfca97e340dd6";
        hash = "sha256-b6WU1o3PfDV/6BTPfPNUFny6oERJCNsDrvflxX3Yvek=";
      })
    ];
  });

  emacs29-macport = import ./make-emacs.nix (mkArgs {
    pname = "emacs-mac";
    version = "29.4";
    variant = "macport";
    rev = "emacs-29.4-mac-10.1";
    hash = "sha256-8OQ+fon9tclbh/eUJ09uqKfMaz9M77QnLIp2R8QB6Ic=";
    patches = fetchpatch: [
      # CVE-2024-53920
      (fetchpatch {
        url = "https://gitweb.gentoo.org/proj/emacs-patches.git/plain/emacs/29.4/07_all_trusted-content.patch?id=f24370de4de0a37304958ec1569d5c50c1745b7f";
        hash = "sha256-zUWM2HDO5MHEB5fC5TCUxzmSafMvXO5usRzCyp9Q7P4=";
      })

      # CVE-2025-1244
      (fetchpatch {
        url = "https://gitweb.gentoo.org/proj/emacs-patches.git/plain/emacs/29.4/06_all_man.patch?id=f24370de4de0a37304958ec1569d5c50c1745b7f";
        hash = "sha256-Vdf6GF5YmGoHTkxiD9mdYH0hgvfovZwrqYN1NQ++U1w=";
      })
    ];

    meta.knownVulnerabilities = [ ];
  });
}
