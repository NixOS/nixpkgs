{
  applyPatches,
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
        let
          mainline = fetchzip {
            url = "mirror://gnu/emacs/${rev}.tar.xz";
            inherit hash;
          };
        in
        {
          inherit mainline;
          "macport" = (
            fetchFromGitHub {
              owner = "jdtsmith";
              repo = "emacs-mac";
              inherit rev hash;
            }
          );
          "plus" = applyPatches {
            src = mainline;
            patches =
              let
                emacsPlus = fetchFromGitHub {
                  owner = "d12frosted";
                  repo = "homebrew-emacs-plus";
                  rev = "19b50cd8dfb967b0c56dd5c73092ad2d72a795f1";
                  hash = "sha256-NVngI/bJdXAFbo4ROELBKdk8PFThklxTXbLXBTIQMcg=";
                };
                majorVersion = lib.versions.major version;
                fileNames =
                  {
                    "30" = [
                      "fix-macos-tahoe-scrolling.patch"
                      "fix-window-role.patch"
                      "round-undecorated-frame.patch"
                      "system-appearance.patch"
                      "treesit-compatibility.patch"
                    ];
                  }
                  .${majorVersion} or (throw "No emacs-plus patches registered for ${majorVersion}");
                dir = "${emacsPlus}/patches/emacs-${majorVersion}";
              in
              map (name: "${dir}/${name}") fileNames;
          };
        }
        .${variant};

      meta = {
        homepage =
          {
            "mainline" = "https://www.gnu.org/software/emacs/";
            "macport" = "https://github.com/jdtsmith/emacs-mac";
            "plus" = "https://github.com/d12frosted/homebrew-emacs-plus";
          }
          .${variant};
        description =
          "Extensible, customizable GNU text editor"
          + lib.optionalString (variant != "mainline") " - ${variant} variant";
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
        + (
          {
            "macport" = ''

              This release initially was built from Mitsuharu Yamamoto's patched source code
              tailored for macOS. Moved to a fork of the latter starting with emacs v30 as the
              original project seems to be currently dormant.
            '';
            "plus" = ''

              This is stock upstream Emacs, plus the patches from the
              homebrew-emacs-plus project.  It offers a wide range of extra
              functionality over regular Emacs package. Emacs+ intent is to give
              the most of ‘plus’ stuff by default, leaving only controversial
              options as opt-in.
            '';
          }
          .${variant} or ""
        );
        changelog =
          {
            "macport" = "https://github.com/jdtsmith/emacs-mac/blob/${rev}/NEWS-mac";
            "mainline" = "https://www.gnu.org/savannah-checkouts/gnu/emacs/news/NEWS.${version}";
            "plus" = "https://github.com/d12frosted/homebrew-emacs-plus/blob/master/NEWS.org";
          }
          .${variant};
        license = lib.licenses.gpl3Plus;
        maintainers =
          {
            "macport" = with lib.maintainers; [
              kfiz
            ];
            "mainline" = with lib.maintainers; [
              AndersonTorres
              adisbladis
              jwiegley
              panchoh
            ];
            "plus" = with lib.maintainers; [
              hraban
            ];
          }
          .${variant};
        platforms =
          {
            "macport" = lib.platforms.darwin;
            "mainline" = lib.platforms.all;
            "plus" = lib.platforms.darwin;
          }
          .${variant};
        mainProgram = "emacs";
      }
      // meta;
    };
  mainlineArgs = {
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
  };
in
{
  emacs30 = import ./make-emacs.nix (mkArgs mainlineArgs);

  emacs30-macport = import ./make-emacs.nix (mkArgs {
    pname = "emacs-mac";
    version = "30.2.50";
    variant = "macport";
    rev = "emacs-mac-30.2";
    hash = "sha256-i/W2Xa6Vk1+T1fs6fa4wJVMLLB6BK8QAPcdmPrU8NwM=";
  });

  # emacs-plus is mainline + some patches
  emacs30-plus = import ./make-emacs.nix (
    mkArgs (
      mainlineArgs
      // {
        variant = "plus";
      }
    )
  );
}
