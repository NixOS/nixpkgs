pkgs: lib: buildPackages:

self: super:

let
  libExt = pkgs.stdenv.hostPlatform.extensions.sharedLibrary;
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

  pq = super.pq.overrideAttrs (old: {
    buildInputs = old.buildInputs or [ ] ++ [ pkgs.postgresql ];
  });

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
}
