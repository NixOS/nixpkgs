/*

# Updating

To update the list of packages from MELPA,

1. Run `./update-melpa`
2. Check for evaluation errors:
     # "../../../../../" points to the default.nix from root of Nixpkgs tree
     env NIXPKGS_ALLOW_BROKEN=1 nix-instantiate --show-trace ../../../../../ -A emacs.pkgs.melpaStablePackages
     env NIXPKGS_ALLOW_BROKEN=1 nix-instantiate --show-trace ../../../../../ -A emacs.pkgs.melpaPackages
3. Run `git commit -m "melpa-packages $(date -Idate)" recipes-archive-melpa.json`

## Update from overlay

Alternatively, run the following command:

./update-from-overlay

It will update both melpa and elpa packages using
https://github.com/nix-community/emacs-overlay. It's almost instantenous and
formats commits for you.

*/

{ lib, pkgs }: variant: self:
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

  buildWithGit = pkg: pkg.overrideAttrs (attrs: {
    nativeBuildInputs =
      (attrs.nativeBuildInputs or [ ]) ++ [ pkgs.git ];
  });

  fix-rtags = pkg:
    if pkg != null then dontConfigure (externalSrc pkg pkgs.rtags)
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

      overrides = lib.optionalAttrs (variant == "stable") {

        # upstream issue: missing file header
        abridge-diff =
          if super.abridge-diff.version == "0.1"
          then markBroken super.abridge-diff
          else super.abridge-diff;

        # upstream issue: missing file header
        bufshow = markBroken super.bufshow;

        # upstream issue: missing file header
        speech-tagger = markBroken super.speech-tagger;

        # upstream issue: missing file header
        textmate = markBroken super.textmate;

        # upstream issue: missing file header
        window-numbering = markBroken super.window-numbering;

        # upstream issue: missing file header
        voca-builder = markBroken super.voca-builder;

        # upstream issue: missing file header
        initsplit = markBroken super.initsplit;

        # upstream issue: missing file header
        jsfmt = markBroken super.jsfmt;

        # upstream issue: missing file header
        maxframe = markBroken super.maxframe;

        # upstream issue: missing file header
        connection = markBroken super.connection;

        # upstream issue: missing file header
        dictionary = markBroken super.dictionary;

        # upstream issue: missing file header
        fold-dwim =
          if super.fold-dwim.version == "1.2"
          then markBroken super.fold-dwim
          else super.fold-dwim;

        # upstream issue: missing file header
        gl-conf-mode =
          if super.gl-conf-mode.version == "0.3"
          then markBroken super.gl-conf-mode
          else super.gl-conf-mode;

        # upstream issue: missing file header
        ligo-mode =
          if super.ligo-mode.version == "0.3"
          then markBroken super.ligo-mode
          else null; # auto-updater is failing; use manual one

        # upstream issue: missing file header
        link = markBroken super.link;

        # upstream issue: missing file header
        org-dp =
          if super.org-dp.version == "1"
          then markBroken super.org-dp
          else super.org-dp;

        # upstream issue: missing file header
        revbufs =
          if super.revbufs.version == "1.2"
          then markBroken super.revbufs
          else super.revbufs;

        # upstream issue: missing file header
        elmine = markBroken super.elmine;

        # upstream issue: missing file header
        ido-complete-space-or-hyphen = markBroken super.ido-complete-space-or-hyphen;

      } // {
        # Expects bash to be at /bin/bash
        ac-rtags = fix-rtags super.ac-rtags;

        airline-themes = super.airline-themes.override {
          inherit (self.melpaPackages) powerline;
        };

        auto-complete-clang-async = super.auto-complete-clang-async.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [ pkgs.llvmPackages.llvm ];
          CFLAGS = "-I${pkgs.llvmPackages.libclang.lib}/include";
          LDFLAGS = "-L${pkgs.llvmPackages.libclang.lib}/lib";
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

        emacsql = super.emacsql.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [ pkgs.sqlite ];

          postBuild = ''
            cd source/sqlite
            make
            cd -
          '';

          postInstall = (old.postInstall or "") + "\n" + ''
            install -m=755 -D source/sqlite/emacsql-sqlite \
              $out/share/emacs/site-lisp/elpa/emacsql-${old.version}/sqlite/emacsql-sqlite
          '';

          stripDebugList = [ "share" ];
        });

        emacsql-sqlite = super.emacsql-sqlite.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [ pkgs.sqlite ];

          postBuild = ''
            cd source/sqlite
            make
            cd -
          '';

          postInstall = (old.postInstall or "") + "\n" + ''
            install -m=755 -D source/sqlite/emacsql-sqlite \
              $out/share/emacs/site-lisp/elpa/emacsql-sqlite-${old.version}/sqlite/emacsql-sqlite
          '';

          stripDebugList = [ "share" ];
        });

        epkg = super.epkg.overrideAttrs (old: {
          postPatch = ''
            substituteInPlace lisp/epkg.el \
              --replace '(call-process "sqlite3"' '(call-process "${pkgs.sqlite}/bin/sqlite3"'
          '';
        });

        erlang = super.erlang.overrideAttrs (attrs: {
          buildInputs = attrs.buildInputs ++ [
            pkgs.perl
            pkgs.ncurses
          ];
        });

        # https://github.com/syl20bnr/evil-escape/pull/86
        evil-escape = super.evil-escape.overrideAttrs (attrs: {
          postPatch = ''
            substituteInPlace evil-escape.el \
              --replace ' ;;; evil' ';;; evil'
          '';
          packageRequires = with self; [ evil ];
        });

        ess-R-data-view = super.ess-R-data-view.override {
          inherit (self.melpaPackages) ess ctable popup;
        };

        flycheck-rtags = fix-rtags super.flycheck-rtags;

        pdf-tools = super.pdf-tools.overrideAttrs (old: {
          # Temporary work around for:
          #   - https://github.com/vedang/pdf-tools/issues/102
          #   - https://github.com/vedang/pdf-tools/issues/103
          #   - https://github.com/vedang/pdf-tools/issues/109
          CXXFLAGS = "-std=c++17";

          nativeBuildInputs = [
            pkgs.autoconf
            pkgs.automake
            pkgs.pkg-config
            pkgs.removeReferencesTo
          ];
          buildInputs = old.buildInputs ++ [ pkgs.libpng pkgs.zlib pkgs.poppler ];
          preBuild = ''
            make server/epdfinfo
            remove-references-to ${lib.concatStringsSep " " (
              map (output: "-t " + output) (
                [
                  pkgs.glib.dev
                  pkgs.libpng.dev
                  pkgs.poppler.dev
                  pkgs.zlib.dev
                  pkgs.cairo.dev
                ]
                ++ lib.optional pkgs.stdenv.isLinux pkgs.stdenv.cc.libc.dev
              )
            )} server/epdfinfo
          '';
          recipe = pkgs.writeText "recipe" ''
            (pdf-tools
            :repo "politza/pdf-tools" :fetcher github
            :files ("lisp/pdf-*.el" "server/epdfinfo"))
          '';
        });

        # Build same version as Haskell package
        hindent = (externalSrc super.hindent pkgs.haskellPackages.hindent).overrideAttrs (attrs: {
          packageRequires = [ self.haskell-mode ];
        });

        irony = super.irony.overrideAttrs (old: {
          cmakeFlags = old.cmakeFlags or [ ] ++ [ "-DCMAKE_INSTALL_BINDIR=bin" ];
          env.NIX_CFLAGS_COMPILE = "-UCLANG_RESOURCE_DIR";
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
          doCheck = pkgs.stdenv.isLinux;
          packageRequires = [ self.emacs ];
          buildInputs = [ pkgs.llvmPackages.libclang self.emacs ];
          nativeBuildInputs = [ pkgs.cmake pkgs.llvmPackages.llvm ];
        });

        # tries to write a log file to $HOME
        insert-shebang = super.insert-shebang.overrideAttrs (attrs: {
          HOME = "/tmp";
        });

        ivy-rtags = fix-rtags super.ivy-rtags;

        jinx = super.jinx.overrideAttrs (old: let
          libExt = pkgs.stdenv.targetPlatform.extensions.sharedLibrary;
        in {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
            pkgs.pkg-config
          ];

          buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.enchant2 ];

          postBuild = ''
            pushd working/jinx
            NIX_CFLAGS_COMPILE="$($PKG_CONFIG --cflags enchant-2) $NIX_CFLAGS_COMPILE"
            $CC -shared -o jinx-mod${libExt} jinx-mod.c -lenchant-2
            popd
          '';

          postInstall = (old.postInstall or "") + "\n" + ''
            pushd source
            outd=$(echo $out/share/emacs/site-lisp/elpa/jinx-*)
            install -m444 --target-directory=$outd jinx-mod${libExt}
            rm $outd/jinx-mod.c $outd/emacs-module.h
            popd
          '';

          meta = old.meta // {
            maintainers = [ lib.maintainers.DamienCassou ];
          };
        });

        sqlite3 = super.sqlite3.overrideAttrs (old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.sqlite ];

          postBuild = ''
            pushd working/sqlite3
            make
            popd
          '';

          postInstall = (old.postInstall or "") + "\n" + ''
            pushd source
            outd=$out/share/emacs/site-lisp/elpa/sqlite3-*
            install -m444 -t $outd sqlite3-api.so
            rm $outd/*.c $outd/*.h
            popd
          '';

          meta = old.meta // {
            maintainers = [ lib.maintainers.DamienCassou ];
          };
        });

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
          postInstall = (attrs.postInstall or "") + "\n" + ''
            outd=$(echo $out/share/emacs/site-lisp/elpa/libgit-**)
            mkdir $outd/build
            install -m444 -t $outd/build ./source/src/libegit2.so
            rm -r $outd/src $outd/Makefile $outd/CMakeLists.txt
          '';
        });

        evil-magit = buildWithGit super.evil-magit;

        eopengrok = buildWithGit super.eopengrok;

        forge = buildWithGit super.forge;

        magit = buildWithGit super.magit;

        magit-find-file = buildWithGit super.magit-find-file;

        magit-gh-pulls = buildWithGit super.magit-gh-pulls;

        magit-imerge = buildWithGit super.magit-imerge;

        magit-lfs = buildWithGit super.magit-lfs;

        magit-org-todos = buildWithGit super.magit-org-todos;

        magit-tbdiff = buildWithGit super.magit-tbdiff;

        magit-topgit = buildWithGit super.magit-topgit;

        magit-vcsh = buildWithGit super.magit-vcsh;

        magit-gerrit = buildWithGit super.magit-gerrit;

        magit-annex = buildWithGit super.magit-annex;

        magit-todos = buildWithGit super.magit-todos;

        magit-filenotify = buildWithGit super.magit-filenotify;

        magit-gitflow = buildWithGit super.magit-gitflow;

        magithub = buildWithGit super.magithub;

        magit-svn = buildWithGit super.magit-svn;

        kubernetes = buildWithGit super.kubernetes;

        kubernetes-evil = buildWithGit super.kubernetes-evil;

        egg = buildWithGit super.egg;

        kapacitor = buildWithGit super.kapacitor;

        gerrit = buildWithGit super.gerrit;

        gerrit-download = buildWithGit super.gerrit-download;

        github-pullrequest = buildWithGit super.github-pullrequest;

        jist = buildWithGit super.jist;

        mandoku = buildWithGit super.mandoku;

        mandoku-tls = buildWithGit super.mandoku-tls;

        magit-p4 = buildWithGit super.magit-p4;

        magit-rbr = buildWithGit super.magit-rbr;

        magit-diff-flycheck = buildWithGit super.magit-diff-flycheck;

        magit-reviewboard = buildWithGit super.magit-reviewboard;

        magit-patch-changelog = buildWithGit super.magit-patch-changelog;

        magit-circleci = buildWithGit super.magit-circleci;

        magit-delta = buildWithGit super.magit-delta;

        orgit = buildWithGit super.orgit;

        orgit-forge = buildWithGit super.orgit-forge;

        ox-rss = buildWithGit super.ox-rss;

        # upstream issue: missing file header
        mhc = super.mhc.override {
          inherit (self.melpaPackages) calfw;
        };

        # missing .NET
        nemerle = markBroken super.nemerle;

        # part of a larger package
        notmuch = dontConfigure super.notmuch;

        pikchr-mode = super.pikchr-mode.overrideAttrs (attrs: {
          postPatch = attrs.postPatch or "" + ''
            substituteInPlace pikchr-mode.el \
              --replace '"pikchr")' '"${lib.getExe pkgs.pikchr}")'
          '';
        });

        rtags = dontConfigure (externalSrc super.rtags pkgs.rtags);

        rtags-xref = dontConfigure super.rtags;

        rime = super.rime.overrideAttrs (old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.librime ];
          preBuild = (old.preBuild or "") + ''
            make lib
            mkdir -p /build/rime-lib
            cp *.so /build/rime-lib
          '';
          postInstall = (old.postInstall or "") + ''
            install -m444 -t $out/share/emacs/site-lisp/elpa/rime-* /build/rime-lib/*.so
          '';
        });

        shm = super.shm.overrideAttrs (attrs: {
          propagatedUserEnvPkgs = [ pkgs.haskellPackages.structured-haskell-mode ];
        });

        # Telega has a server portion for it's network protocol
        telega = super.telega.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [ pkgs.tdlib ];
          nativeBuildInputs = [ pkgs.pkg-config ];

          postPatch = ''
            substituteInPlace telega-customize.el \
              --replace 'defcustom telega-server-command "telega-server"' \
                        "defcustom telega-server-command \"$out/bin/telega-server\""

            substituteInPlace telega-sticker.el --replace '"dwebp' '"${pkgs.libwebp}/bin/dwebp'
            substituteInPlace telega-sticker.el --replace '"ffmpeg' '"${pkgs.ffmpeg}/bin/ffmpeg'

            substituteInPlace telega-vvnote.el --replace '"ffmpeg' '"${pkgs.ffmpeg}/bin/ffmpeg'
          '';

          postBuild = ''
            cd source/server
            make
            cd -
          '';

          postInstall = (old.postInstall or "") + "\n" + ''
            mkdir -p $out/bin
            install -m755 -Dt $out/bin ./source/server/telega-server
          '';
        });

        tokei = super.tokei.overrideAttrs (attrs: {
          postPatch = attrs.postPatch or "" + ''
            substituteInPlace tokei.el \
              --replace 'tokei-program "tokei"' 'tokei-program "${lib.getExe pkgs.tokei}"'
          '';
        });

        treemacs-magit = super.treemacs-magit.overrideAttrs (attrs: {
          # searches for Git at build time
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ pkgs.git ];
        });

        typst-mode = super.typst-mode.overrideAttrs (attrs: {
          postPatch = attrs.postPatch or "" + ''
            substituteInPlace typst-mode.el \
              --replace 'typst-executable-location  "typst"' 'typst-executable-location "${lib.getExe pkgs.typst}"'
          '';
        });

        vdiff-magit = super.vdiff-magit.overrideAttrs (attrs: {
          nativeBuildInputs =
            (attrs.nativeBuildInputs or [ ]) ++ [ pkgs.git ];
        });

        zmq = super.zmq.overrideAttrs (old: {
          stripDebugList = [ "share" ];
          preBuild = ''
            export EZMQ_LIBDIR=$(mktemp -d)
            make
          '';
          nativeBuildInputs = [
            pkgs.autoconf
            pkgs.automake
            pkgs.pkg-config
            pkgs.libtool
            (pkgs.zeromq.override { enableDrafts = true; })
          ];
          postInstall = (old.postInstall or "") + "\n" + ''
            mv $EZMQ_LIBDIR/emacs-zmq.* $out/share/emacs/site-lisp/elpa/zmq-*
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
        instapaper = markBroken super.instapaper;

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
        sql-presto = markBroken super.sql-presto;

        editorconfig = super.editorconfig.overrideAttrs (attrs: {
          propagatedUserEnvPkgs = [ pkgs.editorconfig-core-c ];
        });

        # missing dependencies
        evil-search-highlight-persist = super.evil-search-highlight-persist.overrideAttrs (attrs: {
          packageRequires = with self; [ evil highlight ];
        });

        hamlet-mode = super.hamlet-mode.overrideAttrs (attrs: {
          patches = [
            # Fix build; maintainer email fails to parse
            (pkgs.fetchpatch {
              url = "https://github.com/lightquake/hamlet-mode/commit/253495d1330d6ec88d97fac136c78f57c650aae0.patch";
              sha256 = "dSxS5yuXzCW96CUyvJWwjkhf1FMGBfiKKoBxeDVdz9Y=";
            })
          ];
        });

        helm-rtags = fix-rtags super.helm-rtags;

        # tries to write to $HOME
        php-auto-yasnippets = super.php-auto-yasnippets.overrideAttrs (attrs: {
          HOME = "/tmp";
        });

        racer = super.racer.overrideAttrs (attrs: {
          postPatch = attrs.postPatch or "" + ''
            substituteInPlace racer.el \
              --replace /usr/local/src/rust/src ${pkgs.rustPlatform.rustcSrc}
          '';
        });

        spaceline = super.spaceline.override {
          inherit (self.melpaPackages) powerline;
        };

        vterm = super.vterm.overrideAttrs (old: {
          nativeBuildInputs = [ pkgs.cmake ];
          buildInputs = old.buildInputs ++ [ self.emacs pkgs.libvterm-neovim ];
          cmakeFlags = [
            "-DEMACS_SOURCE=${self.emacs.src}"
            "-DUSE_SYSTEM_LIBVTERM=ON"
          ];
          # we need the proper out directory to exist, so we do this in the
          # postInstall instead of postBuild
          postInstall = (old.postInstall or "") + "\n" + ''
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
              let w3m = "${lib.getBin pkgs.w3m}/bin/w3m"; in
              ''
                substituteInPlace w3m.el \
                --replace 'defcustom w3m-command nil' \
                'defcustom w3m-command "${w3m}"'
              '';
          });
        });

        wordnut = super.wordnut.overrideAttrs (attrs: {
          postPatch = attrs.postPatch or "" + ''
            substituteInPlace wordnut.el \
              --replace 'wordnut-cmd "wn"' 'wordnut-cmd "${lib.getExe pkgs.wordnet}"'
          '';
        });

        mozc = super.mozc.overrideAttrs (attrs: {
          postPatch = attrs.postPatch or "" + ''
            substituteInPlace src/unix/emacs/mozc.el \
              --replace '"mozc_emacs_helper"' '"${pkgs.ibus-engines.mozc}/lib/mozc/mozc_emacs_helper"'
          '';
        });
      };

    in lib.mapAttrs (n: v: if lib.hasAttr n overrides then overrides.${n} else v) super);

in
generateMelpa { }
