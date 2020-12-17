/*

# Updating

To update the list of packages from MELPA,

1. Run ./update-melpa
2. Check for evaluation errors:
env NIXPKGS_ALLOW_BROKEN=1 nix-instantiate --show-trace ../../../../ -A emacsPackages.melpaStablePackages
env NIXPKGS_ALLOW_BROKEN=1 nix-instantiate --show-trace ../../../../ -A emacsPackages.melpaPackages
3. `git commit -m "melpa-packages: $(date -Idate)" recipes-archive-melpa.json`

## Update from overlay

Alternatively, run the following command:

./update-from-overlay

It will update both melpa and elpa packages using
https://github.com/nix-community/emacs-overlay. It's almost
instantenous and formats commits for you.

*/

{ lib, external, pkgs }: variant: self:
let
  dontConfigure = pkg:
    if pkg != null then pkg.override (args: {
      melpaBuild = drv: args.melpaBuild (drv // {
        dontConfigure = true;
      });
    }) else null;

  markBroken = pkg:
    if pkg != null then pkg.override (args: {
      melpaBuild = drv: args.melpaBuild (drv // {
        meta = (drv.meta or { }) // { broken = true; };
      });
    }) else null;

  externalSrc = pkg: epkg:
    if pkg != null then pkg.override (args: {
      melpaBuild = drv: args.melpaBuild (drv // {
        inherit (epkg) src version;

        propagatedUserEnvPkgs = [ epkg ];
      });
    }) else null;

  fix-rtags = pkg:
    if pkg != null then dontConfigure (externalSrc pkg external.rtags)
    else null;

  generateMelpa = lib.makeOverridable ({ archiveJson ? ./recipes-archive-melpa.json
                                       }:
    let
      inherit (import ./libgenerated.nix lib self) melpaDerivation;
      super = (
        lib.listToAttrs (builtins.filter
          (s: s != null)
          (map
            (melpaDerivation variant)
            (lib.importJSON archiveJson)
          )
        )
      );

      overrides = {
        # Expects bash to be at /bin/bash
        ac-rtags = fix-rtags super.ac-rtags;

        airline-themes = super.airline-themes.override {
          inherit (self.melpaPackages) powerline;
        };

        auto-complete-clang-async = super.auto-complete-clang-async.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [ external.llvmPackages.llvm ];
          CFLAGS = "-I${external.llvmPackages.clang}/include";
          LDFLAGS = "-L${external.llvmPackages.clang}/lib";
        });

        # part of a larger package
        caml = dontConfigure super.caml;

        # part of a larger package
        # upstream issue: missing package version
        cmake-mode = dontConfigure super.cmake-mode;

        company-rtags = fix-rtags super.company-rtags;

        easy-kill-extras = super.easy-kill-extras.override {
          inherit (self.melpaPackages) easy-kill;
        };

        dune = dontConfigure super.dune;

        emacsql-sqlite = super.emacsql-sqlite.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [ pkgs.sqlite ];

          postBuild = ''
            cd source/sqlite
            make
            cd -
          '';

          postInstall = ''
            install -m=755 -D source/sqlite/emacsql-sqlite \
              $out/share/emacs/site-lisp/elpa/emacsql-sqlite-${old.version}/sqlite/emacsql-sqlite
          '';

          stripDebugList = [ "share" ];
        });

        # https://github.com/syl20bnr/evil-escape/pull/86
        evil-escape = super.evil-escape.overrideAttrs (attrs: {
          postPatch = ''
            substituteInPlace evil-escape.el \
              --replace ' ;;; evil' ';;; evil'
          '';
          packageRequires = with self; [ evil ];
        });

        evil-magit = super.evil-magit.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        eopengrok = super.eopengrok.overrideAttrs (attrs: {
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        ess-R-data-view = super.ess-R-data-view.override {
          inherit (self.melpaPackages) ess ctable popup;
        };

        forge = super.forge.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        flycheck-rtags = fix-rtags super.flycheck-rtags;

        gnuplot = super.gnuplot.overrideAttrs (old: {
          nativeBuildInputs =
            (old.nativeBuildInputs or [ ]) ++ [ pkgs.autoreconfHook ];
        });

        pdf-tools = super.pdf-tools.overrideAttrs (old: {
          nativeBuildInputs = [ external.pkgconfig ];
          buildInputs = with external; old.buildInputs ++ [ autoconf automake libpng zlib poppler ];
          preBuild = "make server/epdfinfo";
          recipe = pkgs.writeText "recipe" ''
            (pdf-tools
            :repo "politza/pdf-tools" :fetcher github
            :files ("lisp/pdf-*.el" "server/epdfinfo"))
          '';
        });

        # Build same version as Haskell package
        hindent = (externalSrc super.hindent external.hindent).overrideAttrs (attrs: {
          packageRequires = [ self.haskell-mode ];
        });

        irony = super.irony.overrideAttrs (old: {
          cmakeFlags = old.cmakeFlags or [ ] ++ [ "-DCMAKE_INSTALL_BINDIR=bin" ];
          NIX_CFLAGS_COMPILE = "-UCLANG_RESOURCE_DIR";
          preConfigure = ''
            cd server
          '';
          preBuild = ''
            make
            install -D bin/irony-server $out/bin/irony-server
            cd ..
          '';
          checkPhase = ''
            cd source/server
            make check
            cd ../..
          '';
          preFixup = ''
            rm -rf $out/share/emacs/site-lisp/elpa/*/server
          '';
          dontUseCmakeBuildDir = true;
          doCheck = true;
          packageRequires = [ self.emacs ];
          nativeBuildInputs = [ external.cmake external.llvmPackages.llvm external.llvmPackages.clang ];
        });

        # tries to write a log file to $HOME
        insert-shebang = super.insert-shebang.overrideAttrs (attrs: {
          HOME = "/tmp";
        });

        ivy-rtags = fix-rtags super.ivy-rtags;

        libgit = super.libgit.overrideAttrs(attrs: {
          nativeBuildInputs = (attrs.nativeBuildInputs or []) ++ [ pkgs.cmake ];
          buildInputs = attrs.buildInputs ++ [ pkgs.libgit2 ];
          dontUseCmakeBuildDir = true;
          postPatch = ''
            sed -i s/'add_subdirectory(libgit2)'// CMakeLists.txt
          '';
          postBuild = ''
            pushd working/libgit
            make
            popd
          '';
          postInstall = ''
            outd=$(echo $out/share/emacs/site-lisp/elpa/libgit-**)
            mkdir $outd/build
            install -m444 -t $outd/build ./source/src/libegit2.so
            rm -r $outd/src $outd/Makefile $outd/CMakeLists.txt
          '';
        });

        magit = super.magit.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-find-file = super.magit-find-file.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-gh-pulls = super.magit-gh-pulls.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-imerge = super.magit-imerge.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-lfs = super.magit-lfs.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-org-todos = super.magit-org-todos.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-tbdiff = super.magit-tbdiff.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-topgit = super.magit-topgit.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-vcsh = super.magit-vcsh.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-gerrit = super.magit-gerrit.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-annex = super.magit-annex.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-todos = super.magit-todos.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-filenotify = super.magit-filenotify.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-gitflow = super.magit-gitflow.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magithub = super.magithub.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-svn = super.magit-svn.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        kubernetes = super.kubernetes.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        kubernetes-evil = super.kubernetes-evil.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        # upstream issue: missing file header
        mhc = super.mhc.override {
          inherit (self.melpaPackages) calfw;
        };

        # missing .NET
        nemerle = markBroken super.nemerle;

        # part of a larger package
        notmuch = dontConfigure super.notmuch;

        rtags = dontConfigure (externalSrc super.rtags external.rtags);

        rtags-xref = dontConfigure super.rtags;

        shm = super.shm.overrideAttrs (attrs: {
          propagatedUserEnvPkgs = [ external.structured-haskell-mode ];
        });

        # Telega has a server portion for it's network protocol
        telega = super.telega.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [ pkgs.tdlib ];

          postBuild = ''
            cd source/server
            make
            cd -
          '';

          postInstall = ''
            mkdir -p $out/bin
            install -m755 -Dt $out/bin ./source/server/telega-server
          '';
        });

        treemacs-magit = super.treemacs-magit.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        vdiff-magit = super.vdiff-magit.overrideAttrs (attrs: {
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        zmq = super.zmq.overrideAttrs (old: {
          stripDebugList = [ "share" ];
          preBuild = ''
            make
          '';
          nativeBuildInputs = [
            external.autoconf
            external.automake
            external.pkgconfig
            external.libtool
            (external.zeromq.override { enableDrafts = true; })
          ];
          postInstall = ''
            mv $out/share/emacs/site-lisp/elpa/zmq-*/src/.libs/emacs-zmq.so $out/share/emacs/site-lisp/elpa/zmq-*
            rm -r $out/share/emacs/site-lisp/elpa/zmq-*/src
            rm $out/share/emacs/site-lisp/elpa/zmq-*/Makefile
          '';
        });

        # Map legacy renames from emacs2nix since code generation was ported to emacs lisp
        _0blayout = super."0blayout";
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

        # upstream issue: missing file header
        bufshow = markBroken super.bufshow;

        # upstream issue: missing file header
        connection = markBroken super.connection;

        # upstream issue: missing file header
        dictionary = markBroken super.dictionary;

        # upstream issue: missing file header
        elmine = markBroken super.elmine;

        # upstream issue: missing file header
        ido-complete-space-or-hyphen = markBroken super.ido-complete-space-or-hyphen;

        # upstream issue: missing file header
        initsplit = markBroken super.initsplit;

        # upstream issue: missing file header
        instapaper = markBroken super.instapaper;

        # upstream issue: missing file header
        jsfmt = markBroken super.jsfmt;

        # upstream issue: missing file header
        maxframe = markBroken super.maxframe;

        # upstream issue: doesn't build
        magit-stgit = markBroken super.magit-stgit;

        # upstream issue: missing file header
        melancholy-theme = markBroken super.melancholy-theme;

        # upstream issue: doesn't build
        eterm-256color = markBroken super.eterm-256color;

        # upstream issue: doesn't build
        per-buffer-theme = markBroken super.per-buffer-theme;

        # upstream issue: missing file header
        qiita = markBroken super.qiita;

        # upstream issue: missing file header
        speech-tagger = markBroken super.speech-tagger;

        # upstream issue: missing file header
        sql-presto = markBroken super.sql-presto;

        # upstream issue: missing file header
        textmate = markBroken super.textmate;

        # upstream issue: missing file header
        link = markBroken super.link;

        # upstream issue: missing file header
        voca-builder = markBroken super.voca-builder;

        # upstream issue: missing file header
        window-numbering = markBroken super.window-numbering;

        editorconfig = super.editorconfig.overrideAttrs (attrs: {
          propagatedUserEnvPkgs = [ external.editorconfig-core-c ];
        });

        egg = super.egg.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        # missing dependencies
        evil-search-highlight-persist = super.evil-search-highlight-persist.overrideAttrs (attrs: {
          packageRequires = with self; [ evil highlight ];
        });

        kapacitor = super.kapacitor.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        gerrit = super.gerrit.overrideAttrs (attrs: {
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        gerrit-download = super.gerrit-download.overrideAttrs (attrs: {
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        github-pullrequest = super.github-pullrequest.overrideAttrs (attrs: {
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        helm-rtags = fix-rtags super.helm-rtags;

        jist = super.jist.overrideAttrs (attrs: {
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        mandoku = super.mandoku.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        mandoku-tls = super.mandoku-tls.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-p4 = super.magit-p4.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-rbr = super.magit-rbr.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-diff-flycheck = super.magit-diff-flycheck.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-reviewboard = super.magit-reviewboard.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-patch-changelog = super.magit-patch-changelog.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        magit-circleci = super.magit-circleci.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        orgit =
          (super.orgit.overrideAttrs (attrs: {
            # searches for Git at build time
            nativeBuildInputs =
              (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
          }));

        orgit-forge = super.orgit-forge.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ external.git ];
        });

        # tries to write to $HOME
        php-auto-yasnippets = super.php-auto-yasnippets.overrideAttrs (attrs: {
          HOME = "/tmp";
        });

        racer = super.racer.overrideAttrs (attrs: {
          postPatch = attrs.postPatch or "" + ''
            substituteInPlace racer.el \
              --replace /usr/local/src/rust/src ${external.rustPlatform.rustcSrc}
          '';
        });

        spaceline = super.spaceline.override {
          inherit (self.melpaPackages) powerline;
        };

        vterm = super.vterm.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [ self.emacs pkgs.cmake pkgs.libvterm-neovim ];
          cmakeFlags = [
            "-DEMACS_SOURCE=${self.emacs.src}"
            "-DUSE_SYSTEM_LIBVTERM=ON"
          ];
          # we need the proper out directory to exist, so we do this in the
          # postInstall instead of postBuild
          postInstall = ''
            pushd source/build >/dev/null
            make
            install -m444 -t $out/share/emacs/site-lisp/elpa/vterm-** ../*.so
            popd > /dev/null
            rm -rf $out/share/emacs/site-lisp/elpa/vterm-**/{CMake*,build,*.c,*.h}
          '';
        });

        w3m = super.w3m.override (args: {
          melpaBuild = drv: args.melpaBuild (drv // {
            prePatch =
              let w3m = "${lib.getBin external.w3m}/bin/w3m"; in
              ''
                substituteInPlace w3m.el \
                --replace 'defcustom w3m-command nil' \
                'defcustom w3m-command "${w3m}"'
              '';
          });
        });
      };

      # Deprecated legacy aliases for backwards compat
      aliases = lib.listToAttrs (lib.attrValues (lib.mapAttrs (n: v: { name = v; value = builtins.trace "Melpa attribute '${v}' is a legacy alias that will be removed in 21.03, use '${n}' instead" melpaPackages.${n}; }) (lib.filterAttrs (n: v: lib.hasAttr n melpaPackages) {
        "auto-complete-clang-async" = "emacsClangCompleteAsync";
        "vterm" = "emacs-libvterm";
        "0xc" = "_0xc";
        "2048-game" = "_2048-game";
        "4clojure" = "_4clojure";
        "@" = "at";
        "term+" = "term-plus";
        "term+key-intercept" = "term-plus-key-intercept";
        "term+mux" = "term-plus-mux";
        "xml+" = "xml-plus";
      })));

      melpaPackages = lib.mapAttrs (n: v: if lib.hasAttr n overrides then overrides.${n} else v) super;

    in
    melpaPackages // aliases);

in
generateMelpa { }
