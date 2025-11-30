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
  https://github.com/nix-community/emacs-overlay. It's almost instantaneous and
  formats commits for you.
*/

let
  # Read ./recipes-archive-melpa.json in an outer let to make sure we only do this once.
  defaultArchive = builtins.fromJSON (builtins.readFile ./recipes-archive-melpa.json);
in

{ lib, pkgs }:
variant: self:
let
  inherit (import ./lib-override-helper.nix pkgs lib)
    addPackageRequires
    addPackageRequiresIfOlder
    buildWithGit
    dontConfigure
    externalSrc
    fix-rtags
    fixRequireHelmCore
    ignoreCompilationError
    ignoreCompilationErrorIfOlder
    markBroken
    mkHome
    ;

  generateMelpa = lib.makeOverridable (
    {
      archiveJson ? defaultArchive,
    }:
    let
      inherit (import ./libgenerated.nix lib self) melpaDerivation;
      super = (
        lib.listToAttrs (
          builtins.filter (s: s != null) (
            map (melpaDerivation variant) (
              if builtins.isList archiveJson then archiveJson else lib.importJSON archiveJson
            )
          )
        )
      );

      overrides =
        lib.optionalAttrs (variant == "stable") {

          # upstream issue: missing file header
          abridge-diff =
            if super.abridge-diff.version == "0.1" then markBroken super.abridge-diff else super.abridge-diff;

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
            if super.fold-dwim.version == "1.2" then markBroken super.fold-dwim else super.fold-dwim;

          # upstream issue: missing file header
          gl-conf-mode =
            if super.gl-conf-mode.version == "0.3" then markBroken super.gl-conf-mode else super.gl-conf-mode;

          # upstream issue: missing file header
          ligo-mode =
            if super.ligo-mode.version == "0.3" then markBroken super.ligo-mode else super.ligo-mode;

          # upstream issue: missing file header
          link = markBroken super.link;

          # upstream issue: missing file header
          org-dp = if super.org-dp.version == "1" then markBroken super.org-dp else super.org-dp;

          # upstream issue: missing file header
          revbufs = if super.revbufs.version == "1.2" then markBroken super.revbufs else super.revbufs;

          # upstream issue: missing file header
          elmine = markBroken super.elmine;

          # upstream issue: missing file header
          ido-complete-space-or-hyphen = markBroken super.ido-complete-space-or-hyphen;

        }
        // {
          # Expects bash to be at /bin/bash
          ac-rtags = ignoreCompilationError (fix-rtags super.ac-rtags); # elisp error

          age = super.age.overrideAttrs (attrs: {
            postPatch = attrs.postPatch or "" + ''
              substituteInPlace age.el \
                --replace-fail 'age-program (executable-find "age")' 'age-program "${lib.getExe pkgs.age}"'
            '';
          });

          airline-themes = super.airline-themes.override {
            inherit (self.melpaPackages) powerline;
          };

          # https://github.com/Golevka/emacs-clang-complete-async/issues/90
          auto-complete-clang-async =
            (addPackageRequires super.auto-complete-clang-async [ self.auto-complete ]).overrideAttrs
              (old: {
                buildInputs = old.buildInputs ++ [ pkgs.llvmPackages.llvm ];
                env = old.env or { } // {
                  CFLAGS = "-I${lib.getLib pkgs.llvmPackages.libclang}/include";
                  LDFLAGS = "-L${lib.getLib pkgs.llvmPackages.libclang}/lib";
                };
              });

          # part of a larger package
          caml = dontConfigure super.caml;

          # part of a larger package
          # upstream issue: missing package version
          cmake-mode = dontConfigure super.cmake-mode;

          company-rtags = ignoreCompilationError (fix-rtags super.company-rtags); # elisp error

          easy-kill-extras = super.easy-kill-extras.override {
            inherit (self.melpaPackages) easy-kill;
          };

          dune = dontConfigure super.dune;

          emacsql = super.emacsql.overrideAttrs (
            old:
            lib.optionalAttrs (lib.versionOlder old.version "20241115.1939") {
              buildInputs = old.buildInputs ++ [ pkgs.sqlite ];

              postBuild = ''
                pushd sqlite
                make
                popd
              '';

              postInstall =
                (old.postInstall or "")
                + "\n"
                + ''
                  install -m=755 -D sqlite/emacsql-sqlite \
                    $out/share/emacs/site-lisp/elpa/emacsql-${old.version}/sqlite/emacsql-sqlite
                '';

              stripDebugList = [ "share" ];
            }
          );

          emacsql-sqlite = super.emacsql-sqlite.overrideAttrs (
            old:
            lib.optionalAttrs (lib.versionOlder old.version "20240808.2016") {
              buildInputs = old.buildInputs ++ [ pkgs.sqlite ];

              postBuild = ''
                pushd sqlite
                make
                popd
              '';

              postInstall =
                (old.postInstall or "")
                + "\n"
                + ''
                  install -m=755 -D sqlite/emacsql-sqlite \
                    $out/share/emacs/site-lisp/elpa/emacsql-sqlite-${old.version}/sqlite/emacsql-sqlite
                '';

              stripDebugList = [ "share" ];
            }
          );

          epkg = super.epkg.overrideAttrs (old: {
            postPatch = ''
              substituteInPlace lisp/epkg.el \
                --replace '(call-process "sqlite3"' '(call-process "${pkgs.sqlite}/bin/sqlite3"'
            '';
          });

          erlang = super.erlang.overrideAttrs (attrs: {
            nativeBuildInputs = attrs.nativeBuildInputs or [ ] ++ [
              pkgs.perl
            ];
            buildInputs = attrs.buildInputs or [ ] ++ [
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

          flycheck-rtags = ignoreCompilationError (fix-rtags super.flycheck-rtags); # elisp error

          pdf-tools = super.pdf-tools.overrideAttrs (old: {
            # Temporary work around for:
            #   - https://github.com/vedang/pdf-tools/issues/102
            #   - https://github.com/vedang/pdf-tools/issues/103
            #   - https://github.com/vedang/pdf-tools/issues/109
            env = old.env or { } // {
              CXXFLAGS = "-std=c++17";
            };

            nativeBuildInputs = old.nativeBuildInputs ++ [
              pkgs.autoconf
              pkgs.automake
              pkgs.pkg-config
              pkgs.removeReferencesTo
            ];
            buildInputs = old.buildInputs ++ [
              pkgs.libpng
              pkgs.zlib
              pkgs.poppler
            ];
            preBuild = ''
              make server/epdfinfo
              remove-references-to ${
                lib.concatStringsSep " " (
                  map (output: "-t " + output) (
                    [
                      pkgs.glib.dev
                      pkgs.libpng.dev
                      pkgs.poppler.dev
                      pkgs.zlib.dev
                      pkgs.cairo.dev
                    ]
                    ++ lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.stdenv.cc.libc.dev
                  )
                )
              } server/epdfinfo
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

          hotfuzz = super.hotfuzz.overrideAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.cmake ];

            dontUseCmakeBuildDir = true;

            preBuild = ''
              make -j$NIX_BUILD_CORES
            '';

            postInstall =
              (old.postInstall or "")
              + "\n"
              + ''
                install hotfuzz-module.so $out/share/emacs/site-lisp/elpa/hotfuzz-*
              '';
          });

          irony = super.irony.overrideAttrs (old: {
            cmakeFlags = old.cmakeFlags or [ ] ++ [ "-DCMAKE_INSTALL_BINDIR=bin" ];
            env = old.env or { } // {
              NIX_CFLAGS_COMPILE = "-UCLANG_RESOURCE_DIR";
            };
            preConfigure = ''
              pushd server
            '';
            preBuild = ''
              make
              install -D bin/irony-server $out/bin/irony-server
              popd
            '';
            checkPhase = ''
              pushd server
              make check
              popd
            '';
            preFixup = ''
              rm -rf $out/share/emacs/site-lisp/elpa/*/server
            '';
            dontUseCmakeBuildDir = true;
            doCheck = pkgs.stdenv.hostPlatform.isLinux;
            buildInputs = old.buildInputs ++ [ pkgs.llvmPackages.libclang ];
            nativeBuildInputs = old.nativeBuildInputs ++ [
              pkgs.cmake
              pkgs.llvmPackages.llvm
            ];
          });

          # tries to write a log file to $HOME
          insert-shebang = mkHome super.insert-shebang;

          ivy-rtags = ignoreCompilationError (fix-rtags super.ivy-rtags); # elisp error

          jinx = super.jinx.overrideAttrs (
            old:
            let
              libExt = pkgs.stdenv.hostPlatform.extensions.sharedLibrary;
            in
            {
              nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
                pkgs.pkg-config
              ];

              buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.enchant2 ];

              postBuild = ''
                NIX_CFLAGS_COMPILE="$($PKG_CONFIG --cflags enchant-2) $NIX_CFLAGS_COMPILE"
                $CC -shared -o jinx-mod${libExt} jinx-mod.c -lenchant-2
              '';

              postInstall =
                (old.postInstall or "")
                + "\n"
                + ''
                  outd=$(echo $out/share/emacs/site-lisp/elpa/jinx-*)
                  install -m444 --target-directory=$outd jinx-mod${libExt}
                  rm $outd/jinx-mod.c $outd/emacs-module.h
                '';

              meta = old.meta // {
                maintainers = [ lib.maintainers.DamienCassou ];
              };
            }
          );

          sqlite3 = super.sqlite3.overrideAttrs (old: {
            buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.sqlite ];

            postBuild = ''
              make
            '';

            postInstall =
              (old.postInstall or "")
              + "\n"
              + ''
                outd=$out/share/emacs/site-lisp/elpa/sqlite3-*
                install -m444 -t $outd sqlite3-api.so
                rm $outd/*.c $outd/*.h
              '';

            meta = old.meta // {
              maintainers = [ lib.maintainers.DamienCassou ];
            };
          });

          evil-magit = buildWithGit super.evil-magit;

          eopengrok = buildWithGit super.eopengrok;

          forge = buildWithGit super.forge;

          gnuplot = super.gnuplot.overrideAttrs (attrs: {
            postPatch = attrs.postPatch or "" + ''
              substituteInPlace gnuplot.el \
                --replace-fail 'gnuplot-program "gnuplot"' 'gnuplot-program "${lib.getExe pkgs.gnuplot}"'
            '';
          });

          gnuplot-mode = super.gnuplot-mode.overrideAttrs (attrs: {
            postPatch = attrs.postPatch or "" + ''
              substituteInPlace gnuplot-mode.el \
                --replace-fail 'gnuplot-program "gnuplot"' 'gnuplot-program "${lib.getExe pkgs.gnuplot}"'
            '';
          });

          magit = buildWithGit super.magit;

          magit-find-file = buildWithGit super.magit-find-file;

          magit-gh-pulls = buildWithGit super.magit-gh-pulls;

          magit-imerge = buildWithGit super.magit-imerge;

          magit-lfs = buildWithGit super.magit-lfs;

          magit-org-todos = buildWithGit super.magit-org-todos;

          magit-tbdiff = buildWithGit super.magit-tbdiff;

          magit-topgit = ignoreCompilationError (buildWithGit super.magit-topgit); # elisp error

          magit-vcsh = buildWithGit super.magit-vcsh;

          magit-gerrit = buildWithGit super.magit-gerrit;

          magit-annex = buildWithGit super.magit-annex;

          magit-todos = buildWithGit super.magit-todos;

          magit-filenotify = buildWithGit super.magit-filenotify;

          magit-gitflow = buildWithGit super.magit-gitflow;

          magithub = ignoreCompilationError (buildWithGit super.magithub); # elisp error

          magit-svn = buildWithGit super.magit-svn;

          kubernetes = buildWithGit super.kubernetes;

          kubernetes-evil = buildWithGit super.kubernetes-evil;

          egg = buildWithGit super.egg;

          kapacitor = buildWithGit super.kapacitor;

          gerrit = buildWithGit super.gerrit;

          gerrit-download = buildWithGit super.gerrit-download;

          github-pullrequest = buildWithGit super.github-pullrequest;

          jist = buildWithGit super.jist;

          mandoku = addPackageRequires super.mandoku [ self.git ]; # upstream is archived

          magit-p4 = buildWithGit super.magit-p4;

          magit-rbr = buildWithGit super.magit-rbr;

          magit-diff-flycheck = buildWithGit super.magit-diff-flycheck;

          magit-reviewboard = buildWithGit super.magit-reviewboard;

          magit-patch-changelog = buildWithGit super.magit-patch-changelog;

          magit-circleci = buildWithGit super.magit-circleci;

          # https://github.com/dandavison/magit-delta/issues/30
          magit-delta = addPackageRequires (buildWithGit super.magit-delta) [ self.dash ];

          orgit = buildWithGit super.orgit;

          orgit-forge = buildWithGit super.orgit-forge;

          ormolu = super.ormolu.overrideAttrs (attrs: {
            postPatch = attrs.postPatch or "" + ''
              substituteInPlace ormolu.el \
                --replace-fail 'ormolu-process-path "ormolu"' 'ormolu-process-path "${lib.getExe pkgs.ormolu}"'
            '';
          });

          ox-rss = buildWithGit super.ox-rss;

          python-isort = super.python-isort.overrideAttrs (attrs: {
            postPatch = attrs.postPatch or "" + ''
              substituteInPlace python-isort.el \
                --replace '-isort-command "isort"' '-isort-command "${lib.getExe pkgs.isort}"'
            '';
          });

          # upstream issue: missing file header
          # elisp error
          mhc = (ignoreCompilationError super.mhc).override {
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

          rtags = ignoreCompilationError (dontConfigure (externalSrc super.rtags pkgs.rtags)); # elisp error

          rtags-xref = dontConfigure super.rtags;

          rime = super.rime.overrideAttrs (old: {
            buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.librime ];
            preBuild = (old.preBuild or "") + ''
              make lib CC=$CC MODULE_FILE_SUFFIX=${pkgs.stdenv.hostPlatform.extensions.sharedLibrary}
            '';
            postInstall = (old.postInstall or "") + ''
              install -m444 -t $out/share/emacs/site-lisp/elpa/rime-* librime-emacs.*
            '';
          });

          # https://github.com/projectional-haskell/structured-haskell-mode/issues/165
          shm =
            (addPackageRequires super.shm [
              self.haskell-mode
              self.hindent
            ]).overrideAttrs
              (attrs: {
                propagatedUserEnvPkgs = attrs.propagatedUserEnvPkgs or [ ] ++ [
                  pkgs.haskellPackages.structured-haskell-mode
                ];
              });

          # Telega has a server portion for it's network protocol
          # elisp error
          telega = (ignoreCompilationError super.telega).overrideAttrs (old: {
            buildInputs = old.buildInputs ++ [ pkgs.tdlib ];
            nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.pkg-config ];

            postPatch = ''
              substituteInPlace telega-customize.el \
                --replace 'defcustom telega-server-command "telega-server"' \
                          "defcustom telega-server-command \"$out/bin/telega-server\""

              substituteInPlace telega-sticker.el --replace '"dwebp' '"${pkgs.libwebp}/bin/dwebp'
              substituteInPlace telega-sticker.el --replace '"ffmpeg' '"${pkgs.ffmpeg}/bin/ffmpeg'

              substituteInPlace telega-vvnote.el --replace '"ffmpeg' '"${pkgs.ffmpeg}/bin/ffmpeg'
            '';

            postBuild = ''
              pushd server
              make
              popd
            '';

            postInstall =
              (old.postInstall or "")
              + "\n"
              + ''
                mkdir -p $out/bin
                install -m755 -Dt $out/bin server/telega-server
              '';
          });

          tokei = super.tokei.overrideAttrs (attrs: {
            postPatch = attrs.postPatch or "" + ''
              substituteInPlace tokei.el \
                --replace 'tokei-program "tokei"' 'tokei-program "${lib.getExe pkgs.tokei}"'
            '';
          });

          treemacs = super.treemacs.overrideAttrs (attrs: {
            postPatch = (attrs.postPatch or "") + ''
              substituteInPlace src/elisp/treemacs-customization.el \
                --replace 'treemacs-python-executable (treemacs--find-python3)' 'treemacs-python-executable "${lib.getExe pkgs.python3}"'
            '';
          });

          treemacs-magit = super.treemacs-magit.overrideAttrs (attrs: {
            # searches for Git at build time
            nativeBuildInputs = (attrs.nativeBuildInputs or [ ]) ++ [ pkgs.git ];
          });

          typst-mode = super.typst-mode.overrideAttrs (attrs: {
            postPatch = attrs.postPatch or "" + ''
              substituteInPlace typst-mode.el \
                --replace 'typst-executable-location  "typst"' 'typst-executable-location "${lib.getExe pkgs.typst}"'
            '';
          });

          units-mode = super.units-mode.overrideAttrs (attrs: {
            postPatch = attrs.postPatch or "" + ''
              substituteInPlace units-mode.el \
                --replace-fail 'units-binary-path "units"' 'units-binary-path "${lib.getExe pkgs.units}"'
            '';
          });

          vdiff-magit = super.vdiff-magit.overrideAttrs (attrs: {
            nativeBuildInputs = (attrs.nativeBuildInputs or [ ]) ++ [ pkgs.git ];
          });

          zig-mode = super.zig-mode.overrideAttrs (attrs: {
            postPatch = attrs.postPatch or "" + ''
              substituteInPlace zig-mode.el \
                --replace-fail 'zig-zig-bin "zig"' 'zig-zig-bin "${lib.getExe pkgs.zig}"'
            '';
          });

          zmq = super.zmq.overrideAttrs (old: {
            stripDebugList = [ "share" ];
            preBuild = ''
              export EZMQ_LIBDIR=$(mktemp -d)
              make
            '';
            nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [
              pkgs.autoconf
              pkgs.automake
              pkgs.pkg-config
              pkgs.libtool
            ];
            buildInputs = old.buildInputs or [ ] ++ [
              (pkgs.zeromq.override { enableDrafts = true; })
            ];
            postInstall =
              (old.postInstall or "")
              + "\n"
              + ''
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
            packageRequires = with self; [
              evil
              highlight
            ];
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

          helm-rtags = ignoreCompilationError (fix-rtags super.helm-rtags); # elisp error

          # tries to write to $HOME
          php-auto-yasnippets = mkHome super.php-auto-yasnippets;

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
            nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.cmake ];
            buildInputs = old.buildInputs ++ [
              self.emacs
              pkgs.libvterm-neovim
            ];
            cmakeFlags = [
              "-DEMACS_SOURCE=${self.emacs.src}"
              "-DUSE_SYSTEM_LIBVTERM=ON"
            ];
            # we need the proper out directory to exist, so we do this in the
            # postInstall instead of postBuild
            postInstall =
              (old.postInstall or "")
              + "\n"
              + ''
                make
                install -m444 -t $out/share/emacs/site-lisp/elpa/vterm-** ../*.so
                rm -rf $out/share/emacs/site-lisp/elpa/vterm-**/{CMake*,build,*.c,*.h}
              '';
          });

          w3m = super.w3m.override (args: {
            melpaBuild =
              drv:
              args.melpaBuild (
                drv
                // {
                  prePatch =
                    let
                      w3m = "${lib.getBin pkgs.w3m}/bin/w3m";
                    in
                    ''
                      substituteInPlace w3m.el \
                      --replace 'defcustom w3m-command nil' \
                      'defcustom w3m-command "${w3m}"'
                    '';
                }
              );
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

          # Build a helper executable that interacts with the macOS Dictionary.app
          osx-dictionary =
            if pkgs.stdenv.hostPlatform.isDarwin then
              super.osx-dictionary.overrideAttrs (old: {
                postBuild = (old.postBuild or "") + ''
                  $CXX -O3 -framework CoreServices -framework Foundation osx-dictionary.m -o osx-dictionary-cli
                '';
                postInstall =
                  (old.postInstall or "")
                  + "\n"
                  + ''
                    outd=$out/share/emacs/site-lisp/elpa/osx-dictionary-*
                    mkdir -p $out/bin
                    install -m444 -t $out/bin osx-dictionary-cli
                    rm $outd/osx-dictionary.m
                  '';
              })
            else
              super.osx-dictionary;

          # keep-sorted start block=yes newline_separated=yes
          # https://github.com/skeeto/at-el/issues/9
          "@" = ignoreCompilationErrorIfOlder super."@" "20240923.1318";

          "git-gutter-fringe+" = ignoreCompilationError super."git-gutter-fringe+"; # elisp error

          abgaben = addPackageRequires (mkHome super.abgaben) [ self.mu4e ];

          # https://github.com/afroisalreadyinu/abl-mode/issues/9
          abl-mode = addPackageRequires super.abl-mode [ self.f ];

          ac-php-core = super.ac-php-core.overrideAttrs (old: {
            # empty file causing native-compiler-error-empty-byte
            preBuild = ''
              rm --verbose ac-php-comm-tags-data.el
            ''
            + old.preBuild or "";
          });

          # Optimizer error: too much on the stack
          ack-menu = ignoreCompilationError super.ack-menu;

          # https://github.com/gongo/airplay-el/issues/2
          airplay = addPackageRequires super.airplay [ self.request-deferred ];

          alectryon = super.alectryon.overrideAttrs (
            finalAttrs: previousAttrs: {
              # https://github.com/melpa/melpa/pull/9185
              preBuild =
                if lib.versionOlder finalAttrs.version "20241006.1902" then
                  previousAttrs.preBuild or ""
                  + "\n"
                  + ''
                    rm --recursive --verbose etc/elisp/screenshot
                  ''
                else
                  previousAttrs.preBuild or "";
            }
          );

          # https://github.com/gergelypolonkai/alert-termux/issues/2
          alert-termux = addPackageRequires super.alert-termux [ self.alert ];

          # https://github.com/magnars/angular-snippets.el/issues/7
          angular-snippets = addPackageRequires super.angular-snippets [ self.yasnippet ];

          # https://github.com/ragone/asx/pull/3
          asx = addPackageRequires super.asx [ self.request ];

          auctex-cluttex = mkHome super.auctex-cluttex;

          auctex-latexmk = mkHome super.auctex-latexmk;

          # missing optional dependencies
          auto-complete-auctex = addPackageRequires (mkHome super.auto-complete-auctex) [ self.auctex ];

          # depends on distel which is not on any ELPA https://github.com/massemanet/distel/issues/21
          auto-complete-distel = ignoreCompilationError super.auto-complete-distel;

          auto-indent-mode = ignoreCompilationError super.auto-indent-mode; # elisp error

          auto-virtualenv = super.auto-virtualenv.overrideAttrs (
            finalAttrs: previousAttrs: {
              patches = previousAttrs.patches or [ ] ++ [
                (pkgs.fetchpatch {
                  name = "do-not-error-if-the-optional-projectile-is-not-available.patch";
                  url = "https://github.com/marcwebbie/auto-virtualenv/pull/14/commits/9a068974a4e12958200c12c6a23372fa736523c1.patch";
                  hash = "sha256-bqrroFf5AD5SHx6uzBFdVwTv3SbFiO39T+0x03Ves/k=";
                })
              ];
            }
          );

          aws-ec2 = ignoreCompilationError super.aws-ec2; # elisp error

          badger-theme = ignoreCompilationError super.badger-theme; # elisp error

          # https://github.com/BinaryAnalysisPlatform/bap-mode/pull/4
          bap-mode = fixRequireHelmCore (addPackageRequires super.bap-mode [ self.helm-core ]);

          # try to open non-existent ~/.emacs.d/.blog_minimal.config during compilation
          blog-minimal = ignoreCompilationError super.blog-minimal;

          boa-mode = ignoreCompilationError super.boa-mode; # elisp error

          # missing optional dependencies
          # https://github.com/boogie-org/boogie-friends/issues/42
          boogie-friends = ignoreCompilationError (addPackageRequires super.boogie-friends [ self.lsp-mode ]);

          # this package probably should not be compiled in nix build sandbox
          borg = ignoreCompilationError super.borg;

          bpr = super.bpr.overrideAttrs (
            finalAttrs: previousAttrs: {
              # https://github.com/melpa/melpa/pull/9181
              preBuild =
                if lib.versionOlder finalAttrs.version "20241013.1803" then
                  previousAttrs.preBuild or ""
                  + "\n"
                  + ''
                    rm --verbose --force test-bpr.el
                  ''
                else
                  previousAttrs.preBuild or "";
            }
          );

          brainfuck-mode = ignoreCompilationError super.brainfuck-mode; # elisp error

          bts = ignoreCompilationError super.bts; # elisp error

          bts-github = ignoreCompilationError super.bts-github; # elisp error

          buffer-buttons = ignoreCompilationError super.buffer-buttons; # elisp error

          # https://github.com/kiwanami/emacs-calfw/pull/106
          calfw-cal = addPackageRequires super.calfw-cal [ self.calfw ];

          # https://github.com/kiwanami/emacs-calfw/pull/106
          calfw-gcal = addPackageRequires super.calfw-gcal [ self.calfw ];

          # https://github.com/kiwanami/emacs-calfw/pull/106
          calfw-howm = addPackageRequires super.calfw-howm [
            self.calfw
            self.howm
          ];

          # https://github.com/kiwanami/emacs-calfw/pull/106
          calfw-ical = addPackageRequires super.calfw-ical [ self.calfw ];

          # https://github.com/kiwanami/emacs-calfw/pull/106
          calfw-org = addPackageRequires super.calfw-org [ self.calfw ];

          cardano-tx = ignoreCompilationError super.cardano-tx; # elisp error

          cardano-wallet = ignoreCompilationError super.cardano-wallet; # elisp error

          # elisp error and missing optional dependencies
          cask-package-toolset = ignoreCompilationError super.cask-package-toolset;

          # missing optional dependencies
          chee = addPackageRequires super.chee [ self.helm ];

          cheerilee = ignoreCompilationError super.cheerilee; # elisp error

          # elisp error and missing optional dependencies
          # one optional dependency spark is removed in https://github.com/melpa/melpa/pull/9151
          chronometrist = ignoreCompilationError super.chronometrist;

          chronometrist-key-values = super.chronometrist-key-values.overrideAttrs (
            finalAttrs: previousAttrs: {
              # https://github.com/melpa/melpa/pull/9184
              recipe =
                if lib.versionOlder finalAttrs.version "20241006.1831" then
                  ''
                    (chronometrist-key-values :fetcher git :url ""
                     :files (:defaults "elisp/chronometrist-key-values.*"))
                  ''
                else
                  previousAttrs.recipe;
            }
          );

          clingo-mode = super.clingo-mode.overrideAttrs (
            finalAttrs: previousAttrs: {
              patches = previousAttrs.patches or [ ] ++ [
                (pkgs.fetchpatch {
                  name = "add-missing-end-parenthesis.patch";
                  url = "https://github.com/llaisdy/clingo-mode/pull/3/commits/063445a24afb176c3f16af7a2763771dbdc4ecf6.patch";
                  hash = "sha256-OYP5LaZmCUJFgFk1Pf30e7sml8fC+xI4HSyDz7lck7E=";
                })
              ];
            }
          );

          clojure-quick-repls = ignoreCompilationError super.clojure-quick-repls; # elisp error

          # https://github.com/atilaneves/cmake-ide/issues/176
          cmake-ide = addPackageRequires super.cmake-ide [ self.dash ];

          code-review = ignoreCompilationError super.code-review; # elisp error

          # elisp error
          codesearch = ignoreCompilationError (
            super.codesearch.overrideAttrs (
              finalAttrs: previousAttrs: {
                patches =
                  if lib.versionOlder finalAttrs.version "20240827.805" then
                    previousAttrs.patches or [ ]
                    ++ [
                      (pkgs.fetchpatch {
                        name = "remove-unused-dash.patch";
                        url = "https://github.com/abingham/emacs-codesearch/commit/bd24a152ab6ea9f69443ae8e5b7351bb2f990fb6.patch";
                        hash = "sha256-cCHY8Ak2fHuuhymjSF7w2MLPDJa84mBUdKg27mB9yto=";
                      })
                    ]
                  else
                    previousAttrs.patches or [ ];
              }
            )
          );

          # https://github.com/hying-caritas/comint-intercept/issues/2
          comint-intercept = addPackageRequires super.comint-intercept [ self.vterm ];

          company-auctex = mkHome super.company-auctex;

          # depends on distel which is not on any ELPA https://github.com/massemanet/distel/issues/21
          company-distel = ignoreCompilationError super.company-distel;

          company-forge = buildWithGit super.company-forge;

          # qmltypes-table.el causing native-compiler-error-empty-byte
          company-qml = ignoreCompilationError super.company-qml;

          # https://github.com/neuromage/ycm.el/issues/6
          company-ycm = ignoreCompilationError (addPackageRequires super.company-ycm [ self.company ]);

          composable = ignoreCompilationError super.composable; # elisp error

          # missing optional dependencies
          conda = addPackageRequires super.conda [ self.projectile ];

          # needs network during compilation, also native-ice
          consult-gh = ignoreCompilationError (
            super.consult-gh.overrideAttrs (old: {
              propagatedUserEnvPkgs = old.propagatedUserEnvPkgs or [ ] ++ [ pkgs.gh ];
            })
          );

          # needs network during compilation
          consult-gh-embark = ignoreCompilationError super.consult-gh-embark;

          # needs network during compilation
          consult-gh-forge = ignoreCompilationError (buildWithGit super.consult-gh-forge);

          # needs network during compilation
          consult-gh-with-pr-review = ignoreCompilationError super.consult-gh-with-pr-review;

          counsel-gtags = ignoreCompilationError super.counsel-gtags; # elisp error

          # https://github.com/fuxialexander/counsel-notmuch/issues/3
          counsel-notmuch = addPackageRequires super.counsel-notmuch [ self.counsel ];

          # needs dbus during compilation
          counsel-spotify = ignoreCompilationError super.counsel-spotify;

          creole = ignoreCompilationError super.creole; # elisp error

          cssh = ignoreCompilationError super.cssh; # elisp error

          dap-mode = super.dap-mode.overrideAttrs (
            finalAttrs: previousAttrs: {
              # empty file causing native-compiler-error-empty-byte
              preBuild =
                if lib.versionOlder finalAttrs.version "20250131.1624" then
                  ''
                    rm --verbose dapui.el
                  ''
                  + previousAttrs.preBuild or ""
                else
                  previousAttrs.preBuild or "";
            }
          );

          db-pg = ignoreCompilationError super.db-pg; # elisp error

          describe-number = ignoreCompilationError super.describe-number; # elisp error

          # missing optional dependencies: text-translator, not on any ELPA
          dic-lookup-w3m = ignoreCompilationError super.dic-lookup-w3m;

          # https://github.com/nlamirault/dionysos/issues/17
          dionysos = addPackageRequires super.dionysos [ self.f ];

          # https://github.com/emacsorphanage/dired-k/issues/48
          # missing optional dependencies
          dired-k = addPackageRequires super.dired-k [ self.direx ];

          # depends on distel which is not on any ELPA https://github.com/massemanet/distel/issues/21
          distel-completion-lib = ignoreCompilationError super.distel-completion-lib;

          django-mode = ignoreCompilationError super.django-mode; # elisp error

          # elisp error and missing optional dependencies
          drupal-mode = ignoreCompilationError super.drupal-mode;

          e2wm-pkgex4pl = ignoreCompilationError super.e2wm-pkgex4pl; # elisp error

          ecb = ignoreCompilationError super.ecb; # elisp error

          # Optimizer error: too much on the stack
          edit-color-stamp = ignoreCompilationError super.edit-color-stamp;

          edts = ignoreCompilationError (mkHome super.edts); # elisp error

          eimp = super.eimp.overrideAttrs (old: {
            postPatch =
              old.postPatch or ""
              + "\n"
              + ''
                substituteInPlace eimp.el --replace-fail \
                  '(defcustom eimp-mogrify-program "mogrify"' \
                  '(defcustom eimp-mogrify-program "${pkgs.imagemagick}/bin/mogrify"'
              '';
          });

          ein = ignoreCompilationError super.ein; # elisp error

          # missing optional dependencies
          ejc-sql = addPackageRequires super.ejc-sql [
            self.auto-complete
            self.company
          ];

          # missing optional dependencies
          ekg = addPackageRequires super.ekg [ self.denote ];

          el-secretario-mu4e = addPackageRequires super.el-secretario-mu4e [ self.mu4e ];

          elfeed = super.elfeed.overrideAttrs (attrs: {
            postPatch = attrs.postPatch or "" + ''
              substituteInPlace elfeed-curl.el \
                --replace-fail 'elfeed-curl-program-name "curl"' 'elfeed-curl-program-name "${lib.getExe pkgs.curl}"'
            '';
          });

          elisp-sandbox = ignoreCompilationError super.elisp-sandbox; # elisp error

          elnode = ignoreCompilationError super.elnode; # elisp error

          elscreen = super.elscreen.overrideAttrs (old: {
            patches = old.patches or [ ] ++ [
              (pkgs.fetchpatch {
                name = "do-not-require-unneeded-wl.patch";
                url = "https://github.com/knu/elscreen/pull/34/commits/2ffbeb11418d1b98809909c389e7010666d511fd.patch";
                hash = "sha256-7JoDGtFECZEkB3xmMBXZcx6oStkEV06soiqOkDevWtM=";
              })
            ];
          });

          embark-vc = buildWithGit super.embark-vc;

          # https://github.com/nubank/emidje/issues/23
          emidje = addPackageRequires super.emidje [ self.pkg-info ];

          emms-player-mpv-jp-radios = ignoreCompilationError super.emms-player-mpv-jp-radios;

          # depends on later-do which is not on any ELPA
          emms-player-simple-mpv = ignoreCompilationError super.emms-player-simple-mpv;

          # missing optional dependencies
          # https://github.com/isamert/empv.el/pull/96
          empv = addPackageRequires super.empv [ self.hydra ];

          enotify = ignoreCompilationError super.enotify; # elisp error

          # https://github.com/leathekd/ercn/issues/6
          ercn = addPackageRequiresIfOlder super.ercn [ self.dash ] "20250317.2338";

          # missing optional dependencies
          eval-in-repl = addPackageRequires super.eval-in-repl (
            with self;
            [
              alchemist
              cider
              elm-mode
              erlang
              geiser
              hy-mode
              elixir-mode
              js-comint
              lua-mode
              tuareg
              racket-mode
              inf-ruby
              slime
              sly
              sml-mode
            ]
          );

          # elisp error and missing dependencies
          evalator = ignoreCompilationError super.evalator;

          evalator-clojure = ignoreCompilationError super.evalator-clojure; # elisp error

          # https://github.com/PythonNut/evil-easymotion/issues/74
          evil-easymotion = addPackageRequires super.evil-easymotion [ self.evil ];

          evil-mu4e = addPackageRequires super.evil-mu4e [ self.mu4e ];

          # https://github.com/VanLaser/evil-nl-break-undo/issues/2
          evil-nl-break-undo = addPackageRequiresIfOlder super.evil-nl-break-undo [
            self.evil
          ] "20240921.953";

          evil-python-movement = ignoreCompilationError super.evil-python-movement; # elisp error

          evil-tex = mkHome super.evil-tex;

          # Error: Bytecode overflow
          ewal-doom-themes = ignoreCompilationError super.ewal-doom-themes;

          # https://github.com/agzam/exwm-edit/issues/32
          exwm-edit = addPackageRequires super.exwm-edit [ self.exwm ];

          # https://github.com/syl20bnr/flymake-elixir/issues/4
          flymake-elixir = addPackageRequires super.flymake-elixir [ self.flymake-easy ];

          flyparens = ignoreCompilationError super.flyparens; # elisp error

          fold-dwim-org = ignoreCompilationError super.fold-dwim-org; # elisp error

          forge-llm = buildWithGit super.forge-llm;

          frontside-javascript = super.frontside-javascript.overrideAttrs (
            finalAttrs: previousAttrs: {
              # https://github.com/melpa/melpa/pull/9182
              preBuild =
                if lib.versionOlder finalAttrs.version "20240929.1858" then
                  previousAttrs.preBuild or ""
                  + "\n"
                  + ''
                    rm --verbose packages/javascript/test-suppport.el
                  ''
                else
                  previousAttrs.preBuild or "";
            }
          );

          fxrd-mode = ignoreCompilationError super.fxrd-mode; # elisp error

          gams-ac = ignoreCompilationError super.gams-ac; # need gams in PATH during compilation

          # missing optional dependencies
          gap-mode = addPackageRequires super.gap-mode [
            self.company
            self.flycheck
          ];

          gh-notify = buildWithGit super.gh-notify;

          # https://gitlab.com/emacs-stuff/git-commit-insert-issue/-/issues/24
          git-commit-insert-issue = addPackageRequires super.git-commit-insert-issue [ self.glab ];

          # https://github.com/nlamirault/emacs-gitlab/issues/68
          gitlab = addPackageRequires super.gitlab [ self.f ];

          # https://github.com/TxGVNN/gitlab-pipeline/issues/8
          gitlab-pipeline = addPackageRequires super.gitlab-pipeline [ self.glab ];

          # TODO report to upstream
          global-tags = addPackageRequires super.global-tags [ self.s ];

          gnosis = ignoreCompilationError (mkHome super.gnosis); # doing db stuff when compiling

          go = ignoreCompilationError super.go; # elisp error

          graphene = ignoreCompilationError super.graphene; # elisp error

          # https://github.com/ppareit/graphviz-dot-mode/issues/85
          graphviz-dot-mode = addPackageRequires super.graphviz-dot-mode [ self.flycheck ];

          greader = ignoreCompilationError super.greader; # elisp error

          # TODO report to upstream
          guix = addPackageRequires super.guix [ self.geiser-guile ];

          # missing optional dependencies
          gumshoe = addPackageRequires super.gumshoe [ self.perspective ];

          helm-chrome-control = super.helm-chrome-control.overrideAttrs (old: {
            patches = old.patches or [ ] ++ [
              (pkgs.fetchpatch {
                name = "require-helm-core-instead-of-helm.patch";
                url = "https://github.com/xuchunyang/helm-chrome-control/pull/2/commits/7765cd2483adef5cfa6cf77f52259ad6e1dd0daf.patch";
                hash = "sha256-tF+IaICbveYJvd3Tjx52YBBztpjifZdCA4O+Z2r1M3s=";
              })
            ];
          });

          # https://github.com/xuchunyang/helm-chrome-history/issues/3
          helm-chrome-history = fixRequireHelmCore super.helm-chrome-history;

          helm-cider = ignoreCompilationError super.helm-cider; # elisp error

          helm-ext = ignoreCompilationError super.helm-ext; # elisp error

          # TODO report to upstream
          helm-flycheck = fixRequireHelmCore super.helm-flycheck;

          # https://github.com/iory/emacs-helm-ghs/issues/1
          helm-ghs = addPackageRequires super.helm-ghs [ self.helm-ghq ];

          # https://github.com/maio/helm-git/issues/7
          helm-git = addPackageRequires super.helm-git [
            self.helm
            self.magit
          ];

          # https://github.com/yasuyk/helm-git-grep/issues/54
          helm-git-grep = addPackageRequires super.helm-git-grep [ self.helm ];

          # https://github.com/yasuyk/helm-go-package/issues/8
          helm-go-package = fixRequireHelmCore super.helm-go-package;

          # https://github.com/torgeir/helm-js-codemod.el/pull/1
          helm-js-codemod = fixRequireHelmCore super.helm-js-codemod;

          helm-kythe = ignoreCompilationError super.helm-kythe; # elisp error

          # https://github.com/emacs-jp/helm-migemo/issues/8
          helm-migemo = addPackageRequiresIfOlder super.helm-migemo [ self.helm ] "20240921.1550";

          helm-mu = addPackageRequires super.helm-mu [ self.mu4e ];

          # https://github.com/xuchunyang/helm-osx-app/pull/1
          helm-osx-app = addPackageRequires super.helm-osx-app [ self.helm ];

          # https://github.com/cosmicexplorer/helm-rg/issues/36
          helm-rg = ignoreCompilationError super.helm-rg; # elisp error

          # https://github.com/yasuyk/helm-spaces/issues/1
          helm-spaces = fixRequireHelmCore super.helm-spaces;

          hideshow-org = ignoreCompilationError super.hideshow-org; # elisp error

          # https://github.com/purcell/hippie-expand-slime/issues/2
          hippie-expand-slime = addPackageRequires super.hippie-expand-slime [ self.slime ];

          hyperbole = ignoreCompilationError (addPackageRequires (mkHome super.hyperbole) [ self.el-mock ]); # elisp error

          # needs non-existent "browser database directory" during compilation
          # TODO report to upstream about missing dependency websocket
          ibrowse = ignoreCompilationError (addPackageRequires super.ibrowse [ self.websocket ]);

          # elisp error and missing optional dependencies
          identica-mode = ignoreCompilationError super.identica-mode;

          # missing optional dependencies
          idris-mode = addPackageRequires super.idris-mode [ self.flycheck ];

          imbot = ignoreCompilationError super.imbot; # elisp error

          indium = mkHome super.indium;

          # TODO report to upstream
          inlineR = addPackageRequires super.inlineR [ self.ess ];

          # https://github.com/duelinmarkers/insfactor.el/issues/7
          insfactor = addPackageRequires super.insfactor [ self.cider ];

          iregister = super.iregister.overrideAttrs (old: {
            recipe = "";
            files = ''(:defaults (:exclude ".bump-version.el"))'';
          });

          # https://github.com/wandersoncferreira/ivy-clojuredocs/issues/5
          ivy-clojuredocs = addPackageRequires super.ivy-clojuredocs [ self.parseedn ];

          # TODO report to upstream
          jack-connect = addPackageRequires super.jack-connect [ self.dash ];

          javap-mode = ignoreCompilationError super.javap-mode; # elisp error

          jdee = ignoreCompilationError super.jdee; # elisp error

          # https://github.com/fred-o/jekyll-modes/issues/6
          jekyll-modes = addPackageRequires super.jekyll-modes [ self.poly-markdown ];

          jq-mode = super.jq-mode.overrideAttrs (attrs: {
            postPatch = attrs.postPatch or "" + ''
              substituteInPlace jq-mode.el \
                --replace-fail 'jq-interactive-command "jq"' 'jq-interactive-command "${lib.getExe pkgs.jq}"'
              substituteInPlace ob-jq.el \
                --replace-fail 'org-babel-jq-command "jq"' 'org-babel-jq-command "${lib.getExe pkgs.jq}"'
            '';
          });

          jss = ignoreCompilationError super.jss; # elisp error

          # missing optional dependencies: vterm or eat
          julia-snail = addPackageRequires super.julia-snail [ self.eat ];

          kanagawa-themes = super.kanagawa-themes.overrideAttrs (
            finalAttrs: previousAttrs: {
              patches =
                if lib.versionOlder finalAttrs.version "20241015.2237" then
                  previousAttrs.patches or [ ]
                  ++ [
                    (pkgs.fetchpatch {
                      name = "fix-compilation-error.patch";
                      url = "https://github.com/Fabiokleis/kanagawa-emacs/commit/83c2b5c292198b46a06ec0ad62619d83fd965433.patch";
                      hash = "sha256-pB1ht03XCh+BWKHhxBAp701qt/KWAMJ2SQQaN3FgMjU=";
                    })
                  ]
                else
                  previousAttrs.patches or [ ];
            }
          );

          keystore-mode = ignoreCompilationError super.keystore-mode; # elisp error

          kite = ignoreCompilationError super.kite; # elisp error

          # missing optional dependencies
          laas = addPackageRequires super.laas [ self.math-symbol-lists ];

          latex-change-env = mkHome super.latex-change-env;

          latex-extra = mkHome super.latex-extra;

          latex-table-wizard = mkHome super.latex-table-wizard;

          leaf-defaults = ignoreCompilationError super.leaf-defaults; # elisp error

          # https://github.com/abo-abo/lispy/pull/683
          # missing optional dependencies
          lispy = addPackageRequires (mkHome super.lispy) [ self.indium ];

          lsp-origami = ignoreCompilationError super.lsp-origami; # elisp error

          # missing optional dependencies
          magik-mode = addPackageRequires super.magik-mode [
            self.auto-complete
            self.flycheck
          ];

          # https://gitlab.com/arvidnl/magit-gitlab/-/issues/8
          magit-gitlab = addPackageRequires super.magit-gitlab [ self.glab ];

          # missing optional dependencies
          magnatune = addPackageRequires super.magnatune [ self.helm ];

          major-mode-icons = ignoreCompilationError super.major-mode-icons; # elisp error

          malinka = ignoreCompilationError super.malinka; # elisp error

          mastodon = ignoreCompilationError super.mastodon; # elisp error

          # https://github.com/org2blog/org2blog/issues/339
          metaweblog = addPackageRequiresIfOlder super.metaweblog [ self.xml-rpc ] "20250204.1820";

          mu-cite = ignoreCompilationError super.mu-cite; # elisp error

          mu4e-alert = addPackageRequires super.mu4e-alert [ self.mu4e ];

          mu4e-column-faces = addPackageRequires super.mu4e-column-faces [ self.mu4e ];

          mu4e-conversation = addPackageRequires super.mu4e-conversation [ self.mu4e ];

          mu4e-jump-to-list = addPackageRequires super.mu4e-jump-to-list [ self.mu4e ];

          mu4e-marker-icons = addPackageRequires super.mu4e-marker-icons [ self.mu4e ];

          mu4e-overview = addPackageRequires super.mu4e-overview [ self.mu4e ];

          mu4e-query-fragments = addPackageRequires super.mu4e-query-fragments [ self.mu4e ];

          mu4e-views = addPackageRequires super.mu4e-views [ self.mu4e ];

          mu4e-walk = addPackageRequires super.mu4e-walk [ self.mu4e ];

          # https://github.com/magnars/multifiles.el/issues/9
          multifiles = addPackageRequires super.multifiles [ self.dash ];

          # missing optional dependencies
          mykie = addPackageRequires super.mykie [ self.helm ];

          myrddin-mode = ignoreCompilationError super.myrddin-mode; # elisp error

          nand2tetris = super.nand2tetris.overrideAttrs (old: {
            patches = old.patches or [ ] ++ [
              (pkgs.fetchpatch {
                name = "remove-unneeded-require.patch";
                url = "https://github.com/CestDiego/nand2tetris.el/pull/16/commits/d06705bf52f3cf41f55498d88fe15a1064bc2cfa.patch";
                hash = "sha256-8OJXN9MuwBbL0afus53WroIxtIzHY7Bryv5ZGcS/inI=";
              })
            ];
          });

          # elisp error and missing dependency spamfilter which is not on any ELPA
          navi2ch = ignoreCompilationError super.navi2ch;

          navorski = super.navorski.overrideAttrs (old: {
            patches = old.patches or [ ] ++ [
              (pkgs.fetchpatch {
                name = "stop-using-assoc.patch";
                url = "https://github.com/roman/navorski.el/pull/12/commits/b7b6c331898cae239c176346ac87c8551b1e0c72.patch";
                hash = "sha256-CZxOSGuJXATonHMSLGCzO4kOlQqRAOcNNq0i4Qh21y8=";
              })
            ];
          });

          # empty tools/ncl-mode-keywords.el causing native-compiler-error-empty-byte
          ncl-mode = ignoreCompilationError super.ncl-mode;

          # missing optional dependencies
          netease-cloud-music = addPackageRequires super.netease-cloud-music [ self.async ];

          nim-mode = ignoreCompilationError super.nim-mode; # elisp error

          noctilux-theme = ignoreCompilationError super.noctilux-theme; # elisp error

          # https://github.com/nicferrier/emacs-noflet/issues/12
          noflet = ignoreCompilationError super.noflet; # elisp error

          norns = ignoreCompilationError super.norns; # elisp error

          # missing optional dependencies
          nu-mode = addPackageRequires super.nu-mode [ self.evil ];

          # try to open non-existent ~/.emacs.d/.chatgpt-shell.el during compilation
          ob-chatgpt-shell = ignoreCompilationError super.ob-chatgpt-shell;

          org-change = ignoreCompilationError super.org-change; # elisp error

          org-edit-latex = mkHome super.org-edit-latex;

          # https://github.com/GuiltyDolphin/org-evil/issues/24
          # hydra has that error: https://hydra.nixos.org/build/274852065
          # but I cannot reproduce that locally
          org-evil = ignoreCompilationError super.org-evil;

          org-gnome = ignoreCompilationError super.org-gnome; # elisp error

          org-gtd = ignoreCompilationError super.org-gtd; # elisp error

          # TODO report to upstream
          org-kindle = addPackageRequires super.org-kindle [ self.dash ];

          # needs newer org than the Emacs 29.4 builtin one
          org-link-beautify = addPackageRequires super.org-link-beautify [
            self.org
            self.qrencode
          ];

          org-noter = super.org-noter.overrideAttrs (
            finalAttrs: previousAttrs: {
              patches =
                if lib.versionOlder finalAttrs.version "20240915.344" then
                  previousAttrs.patches or [ ]
                  ++ [
                    (pkgs.fetchpatch {
                      name = "catch-error-for-optional-dep-org-roam.patch";
                      url = "https://github.com/org-noter/org-noter/commit/761c551ecc88fec57e840d346c6af5f5b94591d5.patch";
                      hash = "sha256-Diw9DgjANDWu6CBMOlRaihQLOzeAr7VcJPZT579dpYU=";
                    })
                  ]
                else
                  previousAttrs.patches or [ ];
            }
          );

          org-noter-pdftools = mkHome super.org-noter-pdftools;

          org-pdftools = mkHome super.org-pdftools;

          org-projectile = super.org-projectile.overrideAttrs (
            finalAttrs: previousAttrs: {
              # https://github.com/melpa/melpa/pull/9150
              preBuild =
                if lib.versionOlder finalAttrs.version "20240901.2041" then
                  ''
                    rm --verbose org-projectile-helm.el
                  ''
                  + previousAttrs.preBuild or ""
                else
                  previousAttrs.preBuild or "";
            }
          );

          # https://github.com/colonelpanic8/org-project-capture/issues/66
          org-projectile-helm = addPackageRequires super.org-projectile-helm [ self.helm-org ];

          # elisp error and missing optional dependencies
          org-ref = ignoreCompilationError super.org-ref;

          # missing optional dependencies
          org-roam-bibtex = addPackageRequires super.org-roam-bibtex [
            self.helm-bibtex
            self.ivy-bibtex
          ];

          org-special-block-extras = ignoreCompilationError super.org-special-block-extras; # elisp error

          # https://github.com/ichernyshovvv/org-timeblock/issues/65
          org-timeblock = markBroken super.org-timeblock;

          org-trello = ignoreCompilationError super.org-trello; # elisp error

          # Requires xwidgets compiled into emacs, so mark this package
          # as broken if emacs hasn't been compiled with the flag.
          org-xlatex = if self.emacs.withXwidgets then super.org-xlatex else markBroken super.org-xlatex;

          # Optimizer error: too much on the stack
          orgnav = ignoreCompilationError super.orgnav;

          origami-predef = ignoreCompilationError super.origami-predef; # elisp error

          # https://github.com/DarwinAwardWinner/mac-pseudo-daemon/issues/9
          osx-pseudo-daemon = addPackageRequiresIfOlder super.osx-pseudo-daemon [
            self.mac-pseudo-daemon
          ] "20240922.2024";

          # missing optional dependencies
          outlook = addPackageRequires super.outlook [ self.mu4e ];

          pastery = ignoreCompilationError super.pastery; # elisp error

          pdf-meta-edit = super.pdf-meta-edit.overrideAttrs (attrs: {
            postPatch =
              attrs.postPatch or ""
              + "\n"
              + ''
                substituteInPlace pdf-meta-edit.el \
                    --replace-fail '(executable-find "pdftk")' '"${lib.getExe pkgs.pdftk}"'
              '';
          });

          pgdevenv = ignoreCompilationError super.pgdevenv; # elisp error

          pinot = ignoreCompilationError super.pinot; # elisp error

          # https://github.com/polymode/poly-R/issues/41
          poly-R = addPackageRequires super.poly-R [ self.ess ];

          poly-gams = ignoreCompilationError super.poly-gams; # need gams in PATH during compilation

          # missing optional dependencies: direx e2wm yaol, yaol not on any ELPA
          pophint = ignoreCompilationError super.pophint;

          portage-navi = ignoreCompilationError super.portage-navi; # elisp error

          preview-dvisvgm = mkHome super.preview-dvisvgm;

          procress = mkHome super.procress;

          # https://github.com/micdahl/projectile-trailblazer/issues/4
          projectile-trailblazer = addPackageRequires super.projectile-trailblazer [ self.projectile-rails ];

          projmake-mode = ignoreCompilationError super.projmake-mode; # elisp error

          # https://github.com/tumashu/pyim-basedict/issues/4
          pyim-basedict = addPackageRequires super.pyim-basedict [ self.pyim ];

          # TODO report to upstream
          realgud-lldb = super.realgud-lldb.overrideAttrs (old: {
            preBuild =
              old.preBuild or ""
              + "\n"
              + ''
                rm --verbose cask-install.el
              '';
          });

          # empty .yas-compiled-snippets.el causing native-compiler-error-empty-byte
          requirejs = ignoreCompilationError super.requirejs;

          rhtml-mode = ignoreCompilationError super.rhtml-mode; # elisp error

          roguel-ike = ignoreCompilationError super.roguel-ike; # elisp error

          rpm-spec-mode = ignoreCompilationError super.rpm-spec-mode; # elisp error

          # missing optional dependencies
          # https://github.com/emacs-rustic/rustic/pull/93
          rustic = addPackageRequires super.rustic [ self.flycheck ];

          # https://github.com/emacsfodder/emacs-theme-sakura/issues/1
          sakura-theme = addPackageRequiresIfOlder super.sakura-theme [ self.autothemer ] "20240921.1028";

          scad-preview = ignoreCompilationError super.scad-preview; # elisp error

          # https://github.com/wanderlust/semi/pull/29
          # missing optional dependencies
          semi = addPackageRequires super.semi [ self.bbdb-vcard ];

          shadchen = ignoreCompilationError super.shadchen; # elisp error

          shampoo = ignoreCompilationError super.shampoo; # elisp error

          # missing optional dependencies and one of them (mew) is not on any ELPA
          shimbun = ignoreCompilationError (
            addPackageRequires super.shimbun [
              self.apel
              self.flim
              self.w3m
            ]
          );

          slack = mkHome super.slack;

          # https://github.com/ffevotte/slurm.el/issues/14
          slurm-mode = addPackageRequires super.slurm-mode [
            self.dash
            self.s
          ];

          smart-tabs-mode = ignoreCompilationError super.smart-tabs-mode; # elisp error

          # needs network during compilation
          # https://github.com/md-arif-shaikh/soccer/issues/14
          soccer = ignoreCompilationError (addPackageRequires super.soccer [ self.s ]);

          # elisp error and missing optional dependencies
          soundklaus = ignoreCompilationError super.soundklaus;

          # missing optional dependencies
          sparql-mode = addPackageRequires super.sparql-mode [ self.company ];

          speechd-el = ignoreCompilationError super.speechd-el; # elisp error

          spu = ignoreCompilationError super.spu; # elisp error

          # missing optional dependencies
          ssh-tunnels = addPackageRequires super.ssh-tunnels [ self.helm ];

          # https://github.com/brianc/jade-mode/issues/73
          stylus-mode = addPackageRequires super.stylus-mode [ self.sws-mode ];

          # missing optional dependencies
          suggest = addPackageRequires super.suggest [ self.shut-up ];

          sx = ignoreCompilationError super.sx; # elisp error

          symex = ignoreCompilationError super.symex; # elisp error

          term-alert = mkHome super.term-alert;

          # https://github.com/colonelpanic8/term-manager/issues/9
          term-manager = addPackageRequires super.term-manager [ self.eat ];

          texfrag = mkHome super.texfrag;

          # https://github.com/Dspil/text-categories/issues/3
          text-categories = addPackageRequiresIfOlder super.text-categories [ self.dash ] "20240921.824";

          timp = ignoreCompilationError super.timp; # elisp error

          tommyh-theme = ignoreCompilationError super.tommyh-theme; # elisp error

          tramp-hdfs = ignoreCompilationError super.tramp-hdfs; # elisp error

          twtxt = ignoreCompilationError super.twtxt; # needs to read ~/twtxt.txt

          universal-emotions-emoticons = ignoreCompilationError super.universal-emotions-emoticons; # elisp error

          use-package-el-get = addPackageRequires super.use-package-el-get [ self.el-get ];

          vala-mode = ignoreCompilationError super.vala-mode; # elisp error

          # needs network during compilation
          wandbox = ignoreCompilationError super.wandbox; # needs network

          # optional dependency spamfilter is not on any ELPA
          wanderlust = ignoreCompilationError (addPackageRequires super.wanderlust [ self.shimbun ]);

          weechat = ignoreCompilationError super.weechat; # elisp error

          weechat-alert = ignoreCompilationError super.weechat-alert; # elisp error

          weibo = ignoreCompilationError super.weibo; # elisp error

          workgroups2 = ignoreCompilationError super.workgroups2; # elisp error

          ws-butler = super.ws-butler.overrideAttrs (old: {
            # work around https://github.com/NixOS/nixpkgs/issues/436534
            src = pkgs.fetchFromSavannah {
              repo = "emacs/nongnu";
              inherit (old.src) rev outputHash outputHashAlgo;
            };
          });

          # https://github.com/nicklanasa/xcode-mode/issues/28
          xcode-mode = addPackageRequires super.xcode-mode [ self.hydra ];

          xenops = mkHome super.xenops;

          # missing optional dependencies
          xmlunicode = addPackageRequires super.xmlunicode [ self.helm ];

          # https://github.com/canatella/xwwp/issues/19
          xwwp-follow-link-helm = addPackageRequires super.xwwp-follow-link-helm [ self.helm ];

          # https://github.com/canatella/xwwp/issues/18
          xwwp-follow-link-ivy = addPackageRequires super.xwwp-follow-link-ivy [ self.ivy ];

          yara-mode = ignoreCompilationError super.yara-mode; # elisp error

          # https://github.com/leanprover-community/yasnippet-lean/issues/6
          yasnippet-lean = addPackageRequires super.yasnippet-lean [ self.lean-mode ];

          yasnippet-snippets = mkHome super.yasnippet-snippets;

          yatex = ignoreCompilationError super.yatex; # elisp error

          # elisp error and incomplete recipe
          ycm = ignoreCompilationError (
            addPackageRequires super.ycm [
              self.flycheck
              self.f
            ]
          );

          # missing optional dependencies
          zotxt = addPackageRequires super.zotxt [ self.org-noter ];

          # keep-sorted end
        };

    in
    lib.mapAttrs (n: v: if lib.hasAttr n overrides then overrides.${n} else v) super
  );

in
generateMelpa { }
