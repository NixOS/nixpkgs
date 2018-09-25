/*

# Updating

To update the list of packages from MELPA,

1. Clone https://github.com/ttuegel/emacs2nix.
2. Clone https://github.com/milkypostman/melpa.
3. Run `./melpa-stable-packages.sh --melpa PATH_TO_MELPA_CLONE` from emacs2nix.
4. Copy the new `melpa-stable-generated.nix` file into Nixpkgs.
5. Check for evaluation errors: `nix-instantiate ./. -A emacsPackagesNg.melpaStablePackages`.
6. `git add pkgs/applications/editors/emacs-modes/melpa-stable-generated.nix && git commit -m "melpa-stable-packages $(date -Idate)"`

*/

{ external }:

self:

  let
    imported = import ./melpa-stable-generated.nix { inherit (self) callPackage; };

    super = imported;

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
      # upstream issue: mismatched filename
      ack-menu = markBroken super.ack-menu;

      # Expects bash to be at /bin/bash
      ac-rtags = markBroken super.ac-rtags;

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

      # upstream issue: doesn't build
      eterm-256color = markBroken super.eterm-256color;

      # upstream issue: missing dependency highlight
      evil-search-highlight-persist = markBroken super.evil-search-highlight-persist;

      # upstream issue: missing dependency highlight
      floobits  = markBroken super.floobits;

      # missing OCaml
      flycheck-ocaml = markBroken super.flycheck-ocaml;

      # Expects bash to be at /bin/bash
      flycheck-rtags = markBroken super.flycheck-rtags;

      # upstream issue: missing dependency
      fold-dwim-org = markBroken super.fold-dwim-org;

      # build timeout
      graphene = markBroken super.graphene;

      # upstream issue: mismatched filename
      helm-lobsters = markBroken super.helm-lobsters;

      # Expects bash to be at /bin/bash
      helm-rtags = markBroken super.helm-rtags;

      # Build same version as Haskell package
      hindent = super.hindent.overrideAttrs (attrs: {
        version = external.hindent.version;
        src = external.hindent.src;
        packageRequires = [ self.haskell-mode ];
        propagatedUserEnvPkgs = [ external.hindent ];
      });

      # upstream issue: missing file header
      ido-complete-space-or-hyphen = markBroken super.ido-complete-space-or-hyphen;

      # upstream issue: missing file header
      initsplit = markBroken super.initsplit;

      # upstream issue: recipe fails
      insert-shebang = markBroken super.insert-shebang;

      # Expects bash to be at /bin/bash
      ivy-rtags = markBroken super.ivy-rtags;

      # upstream issue: missing file header
      jsfmt = markBroken super.jsfmt;

      # upstream issue: missing file header
      link = markBroken super.link;

      # upstream issue: mismatched filename
      link-hint = markBroken super.link-hint;

      # upstream issue: missing file header
      maxframe = markBroken super.maxframe;

      magit =
        (super.magit.override {
          # version of magit-popup needs to match magit
          # https://github.com/magit/magit/issues/3286
          inherit (self.melpaStablePackages) magit-popup;
        }).overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or []) ++ [ external.git ];
        });

      magit-todos = super.magit-todos.overrideAttrs (attrs: {
        # searches for Git at build time
        nativeBuildInputs =
          (attrs.nativeBuildInputs or []) ++ [ external.git ];
      });

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
      po-mode = markBroken super.po-mode;

      # upstream issue: truncated file
      powershell = markBroken super.powershell;

      # upstream issue: mismatched filename
      processing-snippets = markBroken super.processing-snippets;

      # upstream issue: missing file header
      qiita = markBroken super.qiita;

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

      vdiff-magit =
        (super.vdiff-magit.overrideAttrs (attrs: {
          nativeBuildInputs =
            (attrs.nativeBuildInputs or []) ++ [ external.git ];
        }));

      # upstream issue: missing file header
      voca-builder = markBroken super.voca-builder;

      # upstream issue: missing file header
      window-numbering = markBroken super.window-numbering;
    };

    melpaStablePackages = super // overrides;
  in
    melpaStablePackages // { inherit melpaStablePackages; }
