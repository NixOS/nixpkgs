/*

# Updating

To update the list of packages from MELPA,

1. Run ./update-melpa
2. Check for evaluation errors:
env NIXPKGS_ALLOW_BROKEN=1 nix-instantiate --show-trace ../../../../ -A emacsPackagesNg.melpaStablePackages
env NIXPKGS_ALLOW_BROKEN=1 nix-instantiate --show-trace ../../../../ -A emacsPackagesNg.melpaPackages
3. `git commit -m "melpa-packages: $(date -Idate)" recipes-archive-melpa.json`

*/

{ lib, external }: variant: self: let

  dontConfigure = pkg: if pkg != null then pkg.override (args: {
    melpaBuild = drv: args.melpaBuild (drv // {
      configureScript = "true";
    });
  }) else null;

  markBroken = pkg: if pkg != null then pkg.override (args: {
    melpaBuild = drv: args.melpaBuild (drv // {
      meta = (drv.meta or {}) // { broken = true; };
    });
  }) else null;

  generateMelpa = lib.makeOverridable ({
    archiveJson ? ./recipes-archive-melpa.json
  }: let

    inherit (import ./libgenerated.nix lib self) melpaDerivation;
    super = lib.listToAttrs (map (melpaDerivation variant) (lib.importJSON archiveJson));

    generic = import ./melpa-generic.nix;

    overrides = rec {
      shared = {
        # Expects bash to be at /bin/bash
        ac-rtags = markBroken super.ac-rtags;

        airline-themes = super.airline-themes.override {
          inherit (self.melpaPackages) powerline;
        };

        # upstream issue: missing file header
        bufshow = markBroken super.bufshow;

        # part of a larger package
        caml = dontConfigure super.caml;

        # Expects bash to be at /bin/bash
        company-rtags = markBroken super.company-rtags;

        easy-kill-extras = super.easy-kill-extras.override {
          inherit (self.melpaPackages) easy-kill;
        };

        # upstream issue: missing file header
        elmine = markBroken super.elmine;

        evil-magit = super.evil-magit.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or []) ++ [ external.git ];
        });

        ess-R-data-view = super.ess-R-data-view.override {
          inherit (self.melpaPackages) ess ctable popup;
        };

        # Expects bash to be at /bin/bash
        flycheck-rtags = markBroken super.flycheck-rtags;

        # build timeout
        graphene = markBroken super.graphene;

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

        # tries to write a log file to $HOME
        insert-shebang = super.insert-shebang.overrideAttrs (attrs: {
          HOME = "/tmp";
        });

        # Expects bash to be at /bin/bash
        ivy-rtags = markBroken super.ivy-rtags;

        # upstream issue: missing file header
        jsfmt = markBroken super.jsfmt;

        # upstream issue: missing file header
        maxframe = markBroken super.maxframe;

        magit = super.magit.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or []) ++ [ external.git ];
        });

        magit-todos = super.magit-todos.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or []) ++ [ external.git ];
        });

        magit-filenotify = super.magit-filenotify.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or []) ++ [ external.git ];
        });

      kubernetes = super.kubernetes.overrideAttrs (attrs: {
        # searches for Git at build time
        nativeBuildInputs =
          (attrs.nativeBuildInputs or []) ++ [ external.git ];
      });

      # upstream issue: missing file header
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

        vdiff-magit = super.vdiff-magit.overrideAttrs (attrs: {
          nativeBuildInputs =
            (attrs.nativeBuildInputs or []) ++ [ external.git ];
        });

        # upstream issue: missing file header
        voca-builder = markBroken super.voca-builder;

        # upstream issue: missing file header
        window-numbering = markBroken super.window-numbering;

        # Map legacy renames from emacs2nix since code generation was ported to emacs lisp
        _0blayout = super."0blayout";
        _0xc = super."0xc";
        _2048-game = super."2048-game";
        _4clojure = super."4clojure";
        at = super."@";
        desktop-plus = super."desktop+";
        ghub-plus = super."ghub+";
        git-gutter-plus = super."git-gutter+";
        git-gutter-fringe-plus = super."git-gutter-fringe+";
        ido-completing-read-plus = super."ido-completing-read+";
        image-plus = super."image+";
        image-dired-plus = super."image-dired+";
        markdown-mode-plus = super."markdown-mode+";
        package-plus = super."package+";
        rect-plus = super."rect+";
        term-plus = super."term+";
        term-plus-key-intercept = super."term+key-intercept";
        term-plus-mux = super."term+mux";
        xml-plus = super."xml+";
      };

      stable = {
        # part of a larger package
        # upstream issue: missing package version
        cmake-mode = markBroken (dontConfigure super.cmake-mode);

        # upstream issue: missing file header
        connection = markBroken super.connection;

        # upstream issue: missing file header
        dictionary = markBroken super.dictionary;

        # missing git
        egg = markBroken super.egg;

        # upstream issue: missing dependency redshank
        emr = markBroken super.emr;

        # upstream issue: doesn't build
        eterm-256color = markBroken super.eterm-256color;

        # upstream issue: missing dependency highlight
        evil-search-highlight-persist = markBroken super.evil-search-highlight-persist;

        # upstream issue: missing dependency highlight
        floobits  = markBroken super.floobits;

        # missing OCaml
        flycheck-ocaml = markBroken super.flycheck-ocaml;

        # upstream issue: missing dependency
        fold-dwim-org = markBroken super.fold-dwim-org;

        # build timeout
        graphene = markBroken super.graphene;

        # Expects bash to be at /bin/bash
        helm-rtags = markBroken super.helm-rtags;

        # upstream issue: missing file header
        link = markBroken super.link;

        # missing OCaml
        merlin = markBroken super.merlin;

        # upstream issue: missing file header
        po-mode = markBroken super.po-mode;

        # upstream issue: truncated file
        powershell = markBroken super.powershell;
      };

      unstable = shared // {
        # upstream issue: mismatched filename
        ack-menu = markBroken super.ack-menu;

        editorconfig = super.editorconfig.overrideAttrs (attrs: {
          propagatedUserEnvPkgs = [ external.editorconfig-core-c ];
        });

        egg = super.egg.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or []) ++ [ external.git ];
        });

        # missing dependencies
        evil-search-highlight-persist = super.evil-search-highlight-persist.overrideAttrs (attrs: {
          packageRequires = with self; [ evil highlight ];
        });

        forge = super.forge.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or []) ++ [ external.git ];
        });

        # upstream issue: mismatched filename
        helm-lobsters = markBroken super.helm-lobsters;

        # Expects bash to be at /bin/bash
        helm-rtags = markBroken super.helm-rtags;

        magit-annex = super.magit-annex.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or []) ++ [ external.git ];
        });

        magit-gitflow = super.magit-gitflow.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or []) ++ [ external.git ];
        });

        magithub = super.magithub.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or []) ++ [ external.git ];
        });

        magit-svn = super.magit-svn.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or []) ++ [ external.git ];
        });

        orgit =
          (super.orgit.overrideAttrs (attrs: {
            # searches for Git at build time
            nativeBuildInputs =
              (attrs.nativeBuildInputs or []) ++ [ external.git ];
           }));

        # tries to write to $HOME
        php-auto-yasnippets = super.php-auto-yasnippets.overrideAttrs (attrs: {
          HOME = "/tmp";
        });

        # upstream issue: mismatched filename
        processing-snippets = markBroken super.processing-snippets;

        racer = super.racer.overrideAttrs (attrs: {
          postPatch = attrs.postPatch or "" + ''
            substituteInPlace racer.el \
              --replace /usr/local/src/rust/src ${external.rustPlatform.rustcSrc}
          '';
        });

        # upstream issue: missing file footer
        seoul256-theme = markBroken super.seoul256-theme;

        spaceline = super.spaceline.override {
          inherit (self.melpaPackages) powerline;
        };

        treemacs-magit = super.treemacs-magit.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or []) ++ [ external.git ];
        });

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
    };

  in super // overrides."${variant}");

in generateMelpa { }
