/*

# Updating

To update the list of packages from MELPA,

1. Clone https://github.com/ttuegel/emacs2nix.
2. Clone https://github.com/milkypostman/melpa.
3. Run `./melpa-packages.sh --melpa PATH_TO_MELPA_CLONE` from emacs2nix.
4. Copy the new `melpa-generated.nix` file into Nixpkgs.
5. Check for evaluation errors: `nix-instantiate ./. -A emacsPackagesNg.melpaPackages`.
6. `git add pkgs/applications/editors/emacs-modes/melpa-generated.nix && git commit -m "melpa-packages $(date -Idate)"`

*/

{ lib, external }:

self:

  let
    imported = import ./melpa-generated.nix { inherit (self) callPackage; };
    super = builtins.removeAttrs imported [
      "swbuff-x" # required dependency swbuff is missing
    ];

    dontConfigure = pkg: pkg.override (args: {
      melpaBuild = drv: args.melpaBuild (drv // {
        configureScript = "true";
      });
    });

    markBroken = pkg: pkg.override (args: {
      melpaBuild = drv: args.melpaBuild (drv // {
        meta = (drv.meta or {}) // { broken = true; };
      });
    });

    overrides = {
      # Expects bash to be at /bin/bash
      ac-rtags = markBroken super.ac-rtags;

      # upstream issue: mismatched filename
      ack-menu = markBroken super.ack-menu;

      airline-themes = super.airline-themes.override {
        inherit (self.melpaPackages) powerline;
      };

      # upstream issue: missing file header
      bufshow = markBroken super.bufshow;

      # part of a larger package
      caml = dontConfigure super.caml;

      # part of a larger package
      # upstream issue: missing package version
      cmake-mode = markBroken (dontConfigure super.cmake-mode);

      # Expects bash to be at /bin/bash
      company-rtags = markBroken super.company-rtags;

      # upstream issue: missing file header
      connection = markBroken super.connection;

      # upstream issue: missing file header
      dictionary = markBroken super.dictionary;

      easy-kill-extras = super.easy-kill-extras.override {
        inherit (self.melpaPackages) easy-kill;
      };

      # missing git
      egg = markBroken super.egg;

      # upstream issue: missing file header
      elmine = markBroken super.elmine;

      # upstream issue: missing dependency redshank
      emr = markBroken super.emr;

      ess-R-data-view = super.ess-R-data-view.override {
        inherit (self.melpaPackages) ess ctable popup;
      };

      # upstream issue: missing dependency highlight
      evil-search-highlight-persist = markBroken super.evil-search-highlight-persist;

      # upstream issue: missing dependency highlight
      floobits  = markBroken super.floobits;

      # missing OCaml
      flycheck-ocaml = markBroken super.flycheck-ocaml;

      # Expects bash to be at /bin/bash
      flycheck-rtags = markBroken super.flycheck-rtags;

      # upstream issue: missing file header
      fold-dwim = markBroken super.fold-dwim;

      # build timeout
      graphene = markBroken super.graphene;

      # upstream issue: mismatched filename
      helm-lobsters = markBroken super.helm-lobsters;

      # Expects bash to be at /bin/bash
      helm-rtags = markBroken super.helm-rtags;

      # upstream issue: missing file header
      helm-words = markBroken super.helm-words;

      # upstream issue: missing file header
      ido-complete-space-or-hyphen = markBroken super.ido-complete-space-or-hyphen;

      # upstream issue: missing file header
      initsplit = super.initsplit;

      # Expects bash to be at /bin/bash
      ivy-rtags = markBroken super.ivy-rtags;

      # upstream issue: missing file header
      jsfmt = markBroken super.jsfmt;

      # upstream issue: missing file header
      link = markBroken super.link;

      # upstream issue: missing file header
      maxframe = markBroken super.maxframe;

      # version of magit-popup needs to match magit
      # https://github.com/magit/magit/issues/3286
      magit = super.magit.override {
        inherit (self.melpaPackages) magit-popup;
      };

      # missing OCaml
      merlin = markBroken super.merlin;

      mhc = super.mhc.override {
        inherit (self.melpaPackages) calfw;
      };

      # missing .NET
      nemerle = markBroken super.nemerle;

      # part of a larger package
      notmuch = dontConfigure super.notmuch;

      # missing OCaml
      ocp-indent = markBroken super.ocp-indent;

      # upstream issue: missing dependency
      org-readme = markBroken super.org-readme;

      # upstream issue: missing file header
      perl-completion = markBroken super.perl-completion;

      # upstream issue: truncated file
      powershell = markBroken super.powershell;

      # upstream issue: mismatched filename
      processing-snippets = markBroken super.processing-snippets;

      # upstream issue: missing file header
      qiita = markBroken super.qiita;

      # upstream issue: missing package version
      quack = markBroken super.quack;

      # upstream issue: missing file header
      railgun = markBroken super.railgun;

      # upstream issue: missing file footer
      seoul256-theme = markBroken super.seoul256-theme;

      # upstream issue: missing dependency highlight
      sonic-pi  = markBroken super.sonic-pi;

      spaceline = super.spaceline.override {
        inherit (self.melpaPackages) powerline;
      };

      # upstream issue: missing file header
      speech-tagger = markBroken super.speech-tagger;

      # upstream issue: missing file header
      stgit = markBroken super.stgit;

      # upstream issue: missing file header
      tawny-mode = markBroken super.tawny-mode;

      # upstream issue: missing file header
      textmate = markBroken super.textmate;

      # missing OCaml
      utop = markBroken super.utop;

      # upstream issue: missing file header
      voca-builder = markBroken super.voca-builder;

      # upstream issue: missing dependency
      weechat-alert = markBroken super.weechat-alert;

      # upstream issue: missing file header
      window-numbering = markBroken super.window-numbering;

      # upstream issue: missing file header
      zeitgeist = markBroken super.zeitgeist;

      w3m = super.w3m.override (args: {
        melpaBuild = drv: args.melpaBuild (drv // {
          prePatch =
            let w3m = "${lib.getBin external.w3m}/bin/w3m"; in ''
              substituteInPlace w3m.el \
                --replace 'defcustom w3m-command nil' \
                          'defcustom w3m-command "${w3m}"'
            '';
        });
      });
    };

    melpaPackages = super // overrides;
  in
    melpaPackages // { inherit melpaPackages; }
