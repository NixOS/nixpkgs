pkgs: lib: buildPackages:

self: super:

let
  libExt = pkgs.stdenv.hostPlatform.extensions.sharedLibrary;
  inherit (import ./lib-override-helper.nix pkgs lib)
    addPackageRequires
    addPackageRequiresIfOlder
    ignoreCompilationError
    ignoreCompilationErrorIfOlder
    mkHome
    mkHomeIfOlder
    ;
in
{
  cl-lib = null; # builtin
  cl-print = null; # builtin
  tle = null; # builtin
  advice = null; # builtin

  # Compilation instructions for the Ada executables:
  # https://www.nongnu.org/ada-mode/
  ada-mode = super.ada-mode.overrideAttrs (
    finalAttrs: previousAttrs: {
      # actually unpack source of ada-mode and wisi
      # which are both needed to compile the tools
      # we need at runtime
      dontUnpack = false;
      srcs = [
        super.ada-mode.src
        self.wisi.src
      ];

      sourceRoot = "ada-mode-${finalAttrs.version}";

      nativeBuildInputs = previousAttrs.nativeBuildInputs or [ ] ++ [
        buildPackages.gnat
        buildPackages.gprbuild
        buildPackages.dos2unix
        buildPackages.re2c
      ];

      buildInputs = previousAttrs.buildInputs or [ ] ++ [ pkgs.gnatPackages.gnatcoll-xref ];

      buildPhase = ''
        runHook preBuild
        ./build.sh -j$NIX_BUILD_CORES
        runHook postBuild
      '';

      postInstall =
        previousAttrs.postInstall or ""
        + "\n"
        + ''
          ./install.sh "$out"
        '';

      meta = previousAttrs.meta // {
        maintainers = [ lib.maintainers.sternenseemann ];
      };
    }
  );

  # native-compiler-error-empty-byte in old versions
  ada-ref-man = ignoreCompilationErrorIfOlder super.ada-ref-man "2020.1.0.20201129.190419";

  # elisp error in old versions
  ampc = ignoreCompilationErrorIfOlder super.ampc "0.2.0.20240220.181558";

  auctex = mkHome super.auctex;

  auctex-cont-latexmk = mkHome super.auctex-cont-latexmk;

  auctex-label-numbers = mkHome super.auctex-label-numbers;

  # missing optional dependencies https://codeberg.org/rahguzar/consult-hoogle/issues/4
  consult-hoogle = addPackageRequiresIfOlder super.consult-hoogle [ self.consult ] "0.2.2";

  # missing optional dependencies https://github.com/jacksonrayhamilton/context-coloring/issues/10
  context-coloring = addPackageRequires super.context-coloring [ self.js2-mode ];

  cpio-mode = ignoreCompilationError super.cpio-mode; # elisp error

  # fixed in https://git.savannah.gnu.org/cgit/emacs/elpa.git/commit/?h=externals/dbus-codegen&id=cfc46758c6252a602eea3dbc179f8094ea2a1a85
  dbus-codegen = ignoreCompilationErrorIfOlder super.dbus-codegen "0.1.0.20201127.221326"; # elisp error

  ebdb = super.ebdb.overrideAttrs (
    finalAttrs: previousAttrs:
    let
      applyOrgRoamMissingPatch = lib.versionOlder finalAttrs.version "0.8.22.0.20240205.070828";
    in
    {
      dontUnpack = !applyOrgRoamMissingPatch;
      patches =
        if applyOrgRoamMissingPatch then
          previousAttrs.patches or [ ]
          ++ [
            (pkgs.fetchpatch {
              name = "fix-comilation-error-about-missing-org-roam.patch";
              url = "https://github.com/girzel/ebdb/commit/058f30a996eb9074feac8f94db4eb49e85ae08f1.patch";
              hash = "sha256-UI72N3lCgro6bG75sWnbw9truREToQHEzZ1TeQAIMjo=";
            })
          ]
        else
          previousAttrs.patches or null;
      preBuild =
        if applyOrgRoamMissingPatch then
          previousAttrs.preBuild or ""
          + "\n"
          + ''
            pushd ..
            local content_directory=$ename-$version
            src=$PWD/$content_directory.tar
            tar --create --verbose --file=$src $content_directory
            popd
          ''
        else
          previousAttrs.preBuild or null;
    }
  );

  eglot = super.eglot.overrideAttrs (
    finalAttrs: previousAttrs: {
      postInstall =
        previousAttrs.postInstall or ""
        # old versions do not include an info manual
        + lib.optionalString (lib.versionAtLeast "1.17.0.20240829.5352" finalAttrs.version) ''
          local info_file=eglot.info
          pushd $out/share/emacs/site-lisp/elpa/eglot-*
          # specify output info file to override the one defined in eglot.texi
          makeinfo --output=$info_file eglot.texi
          install-info $info_file dir
          popd
        '';
    }
  );

  jinx = super.jinx.overrideAttrs (old: {
    dontUnpack = false;

    nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ pkgs.pkg-config ];

    buildInputs = old.buildInputs or [ ] ++ [ pkgs.enchant2 ];

    postBuild =
      old.postBuild or ""
      + "\n"
      + ''
        NIX_CFLAGS_COMPILE="$($PKG_CONFIG --cflags enchant-2) $NIX_CFLAGS_COMPILE"
        $CC -shared -o jinx-mod${libExt} jinx-mod.c -lenchant-2
      '';

    postInstall =
      old.postInstall or ""
      + "\n"
      + ''
        outd=$out/share/emacs/site-lisp/elpa/jinx-*
        install -m444 -t $outd jinx-mod${libExt}
        rm $outd/jinx-mod.c $outd/emacs-module.h
      '';

    meta = old.meta // {
      maintainers = [ lib.maintainers.DamienCassou ];
    };
  });

  notes-mode = (mkHome super.notes-mode).overrideAttrs (old: {
    dontUnpack = false;
    buildInputs = old.buildInputs or [ ] ++ [ pkgs.perl ];
    nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ pkgs.perl ];
    preInstall =
      old.preInstall or ""
      + "\n"
      + ''
        patchShebangs --build mkconfig
        pushd ..
        local content_directory=$ename-$version
        src=$PWD/$content_directory.tar
        tar --create --verbose --file=$src $content_directory
        popd
      '';
    postFixup =
      old.postFixup or ""
      + "\n"
      + ''
        patchShebangs --host --update $out/share/emacs/site-lisp/elpa/$ename-$version/mkconfig
      '';
  });

  plz = super.plz.overrideAttrs (old: {
    dontUnpack = false;
    postPatch =
      old.postPatch or ""
      + "\n"
      + ''
        substituteInPlace plz.el \
          --replace-fail 'plz-curl-program "curl"' 'plz-curl-program "${lib.getExe pkgs.curl}"'
      '';
    preInstall =
      old.preInstall or ""
      + "\n"
      + ''
        tar -cf "$ename-$version.tar" --transform "s,^,$ename-$version/," * .[!.]*
        src="$ename-$version.tar"
      '';
  });

  # https://sourceware.org/bugzilla/show_bug.cgi?id=32185
  poke = addPackageRequires super.poke [ self.poke-mode ];

  pq = super.pq.overrideAttrs (old: {
    buildInputs = old.buildInputs or [ ] ++ [ pkgs.postgresql ];
  });

  preview-auto = mkHome super.preview-auto;

  preview-tailor = mkHome super.preview-tailor;

  # https://debbugs.gnu.org/cgi/bugreport.cgi?bug=73325
  psgml = ignoreCompilationError super.psgml; # elisp error

  # native-ice https://github.com/mattiase/relint/issues/15
  relint = ignoreCompilationError super.relint;

  shen-mode = ignoreCompilationErrorIfOlder super.shen-mode "0.1.0.20221221.82050"; # elisp error

  # native compilation for tests/seq-tests.el never ends
  # delete tests/seq-tests.el to workaround this
  seq = super.seq.overrideAttrs (old: {
    dontUnpack = false;
    postUnpack =
      old.postUnpack or ""
      + "\n"
      + ''
        local content_directory=$(echo seq-*)
        rm --verbose $content_directory/tests/seq-tests.el
        src=$PWD/$content_directory.tar
        tar --create --verbose --file=$src $content_directory
      '';
  });

  # https://github.com/alphapapa/taxy.el/issues/3
  taxy = super.taxy.overrideAttrs (old: {
    dontUnpack = false;
    postUnpack =
      old.postUnpack or ""
      + "\n"
      + ''
        local content_directory=$ename-$version
        rm --verbose --recursive $content_directory/examples
        src=$PWD/$content_directory.tar
        tar --create --verbose --file=$src $content_directory
      '';
  });

  tex-parens = mkHomeIfOlder super.tex-parens "0.4.0.20240630.70456";

  timerfunctions = ignoreCompilationErrorIfOlder super.timerfunctions "1.4.2.0.20201129.225252";

  # kv is required in triples-test.el
  # Alternatively, we can delete that file.  But adding a dependency is easier.
  triples = addPackageRequires super.triples [ self.kv ];

  wisitoken-grammar-mode = ignoreCompilationError super.wisitoken-grammar-mode; # elisp error

  xeft = super.xeft.overrideAttrs (old: {
    dontUnpack = false;
    buildInputs = old.buildInputs or [ ] ++ [ pkgs.xapian ];
    buildPhase =
      old.buildPhase or ""
      + ''
        $CXX -shared -o xapian-lite${libExt} xapian-lite.cc -lxapian
      '';
    postInstall =
      old.postInstall or ""
      + "\n"
      + ''
        outd=$out/share/emacs/site-lisp/elpa/xeft-*
        install -m444 -t $outd xapian-lite${libExt}
        rm $outd/xapian-lite.cc $outd/emacs-module.h $outd/emacs-module-prelude.h $outd/demo.gif $outd/Makefile
      '';
  });

  # native-ice https://github.com/mattiase/xr/issues/9
  xr = ignoreCompilationError super.xr;
}
