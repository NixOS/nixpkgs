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

{ lib }:

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
      ac-php = super.ac-php.override {
        inherit (self.melpaPackages) company popup;
      };

      # upstream issue: mismatched filename
      ack-menu = markBroken super.ack-menu;

      airline-themes = super.airline-themes.override {
        inherit (self.melpaPackages) powerline;
      };

      # upstream issue: missing file header
      bufshow = markBroken super.bufshow;

      # part of a larger package
      # upstream issue: missing package version
      cmake-mode = markBroken (dontConfigure super.cmake-mode);

      # upstream issue: missing file header
      cn-outline = markBroken super.cn-outline;

      # upstream issue: missing file header
      connection = markBroken super.connection;

      # upstream issue: missing file header
      crux = markBroken super.crux;

      # upstream issue: missing file header
      dictionary = markBroken super.dictionary;

      easy-kill-extras = super.easy-kill-extras.override {
        inherit (self.melpaPackages) easy-kill;
      };

      # missing git
      egg = markBroken super.egg;

      # upstream issue: missing file header
      elmine = markBroken super.elmine;

      ess-R-data-view = super.ess-R-data-view.override {
        inherit (self.melpaPackages) ess ctable popup;
      };

      ess-R-object-popup = super.ess-R-object-popup.override {
        inherit (self.melpaPackages) ess popup;
      };

      # missing OCaml
      flycheck-ocaml = markBroken super.flycheck-ocaml;

      # upstream issue: missing file header
      fold-dwim = markBroken super.fold-dwim;

      # build timeout
      graphene = markBroken super.graphene;

      # upstream issue: mismatched filename
      helm-lobsters = markBroken super.helm-lobsters;

      # upstream issue: missing file header
      helm-words = markBroken super.helm-words;

      # upstream issue: missing file header
      ido-complete-space-or-hyphen = markBroken super.ido-complete-space-or-hyphen;

      # upstream issue: missing file header
      initsplit = markBroken super.initsplit;

      # upstream issue: missing file header
      jsfmt = markBroken super.jsfmt;

      # upstream issue: missing file header
      link = markBroken super.link;

      # upstream issue: mismatched filename
      link-hint = markBroken super.link-hint;

      # part of a larger package
      llvm-mode = dontConfigure super.llvm-mode;

      # upstream issue: missing file header
      maxframe = markBroken super.maxframe;

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

      spaceline = super.spaceline.override {
        inherit (self.melpaPackages) powerline;
      };

      # upstream issue: missing file header
      speech-tagger = markBroken super.speech-tagger;

      # upstream issue: missing file header
      stgit = markBroken super.stgit;

      # upstream issue: missing file header
      textmate = markBroken super.textmate;

      # missing OCaml
      utop = markBroken super.utop;

      # upstream issue: missing file header
      voca-builder = markBroken super.voca-builder;

      # upstream issue: missing file header
      window-numbering = markBroken super.window-numbering;

      # upstream issue: missing file header
      zeitgeist = markBroken super.zeitgeist;
    };

    melpaPackages = super // overrides;
  in
    melpaPackages // { inherit melpaPackages; }
