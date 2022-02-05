{ lib, stdenv, fetchurl, fetchpatch, python3Packages, makeWrapper, gettext, installShellFiles
, re2Support ? true
, rustSupport ? stdenv.hostPlatform.isLinux, rustPlatform
, fullBuild ? false
, gitSupport ? fullBuild
, guiSupport ? fullBuild, tk
, highlightSupport ? fullBuild
, ApplicationServices
# test dependencies
, runCommand
, unzip
, which
, sqlite
, git
, cacert
, gnupg
}:

let
  inherit (python3Packages) docutils python fb-re2 pygit2 pygments;

  self = python3Packages.buildPythonApplication rec {
    pname = "mercurial";
    version = "6.0.2";

    src = fetchurl {
      url = "https://mercurial-scm.org/release/mercurial-${version}.tar.gz";
      sha256 = "sha256-X7TDbThWKS6/WEBR1ZMG2WrYqjK1U3RSsdnEdvlasRo=";
    };

    format = "other";

    passthru = { inherit python; }; # pass it so that the same version can be used in hg2git

    cargoDeps = if rustSupport then rustPlatform.fetchCargoTarball {
      inherit src;
      name = "${pname}-${version}";
      sha256 = "sha256-rIG57oPCTUz4HNJyuMBPlKTSh02ecF5052Q1P9wGq1s=";
      sourceRoot = "${pname}-${version}/rust";
    } else null;
    cargoRoot = if rustSupport then "rust" else null;

    propagatedBuildInputs = lib.optional re2Support fb-re2
      ++ lib.optional gitSupport pygit2
      ++ lib.optional highlightSupport pygments;
    nativeBuildInputs = [ makeWrapper gettext installShellFiles ]
      ++ lib.optionals rustSupport (with rustPlatform; [
           cargoSetupHook
           rust.cargo
           rust.rustc
         ]);
    buildInputs = [ docutils ]
      ++ lib.optionals stdenv.isDarwin [ ApplicationServices ];

    makeFlags = [ "PREFIX=$(out)" ]
      ++ lib.optional rustSupport "PURE=--rust";

    postInstall = (lib.optionalString guiSupport ''
      mkdir -p $out/etc/mercurial
      cp contrib/hgk $out/bin
      cat >> $out/etc/mercurial/hgrc << EOF
      [extensions]
      hgk=$out/lib/${python.libPrefix}/site-packages/hgext/hgk.py
      EOF
      # setting HG so that hgk can be run itself as well (not only hg view)
      WRAP_TK=" --set TK_LIBRARY ${tk}/lib/${tk.libPrefix}
                --set HG $out/bin/hg
                --prefix PATH : ${tk}/bin "
    '') + ''
      for i in $(cd $out/bin && ls); do
        wrapProgram $out/bin/$i \
          $WRAP_TK
      done

      # copy hgweb.cgi to allow use in apache
      mkdir -p $out/share/cgi-bin
      cp -v hgweb.cgi contrib/hgweb.wsgi $out/share/cgi-bin
      chmod u+x $out/share/cgi-bin/hgweb.cgi

      installShellCompletion --cmd hg \
        --bash contrib/bash_completion \
        --zsh contrib/zsh_completion
    '';

    passthru.tests = {
      mercurial-tests = makeTests { flags = "--with-hg=$MERCURIAL_BASE/bin/hg"; };
    };

    meta = with lib; {
      description = "A fast, lightweight SCM system for very large distributed projects";
      homepage = "https://www.mercurial-scm.org";
      downloadPage = "https://www.mercurial-scm.org/release/";
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ eelco lukegb pacien ];
      platforms = platforms.unix;
    };
  };

  makeTests = { mercurial ? self, nameSuffix ? "", flags ? "" }: runCommand "${mercurial.pname}${nameSuffix}-tests" {
    inherit (mercurial) src;

    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";  # needed for git
    MERCURIAL_BASE = mercurial;
    nativeBuildInputs = [
      python
      unzip
      which
      sqlite
      git
      gnupg
    ];

    postPatch = ''
      patchShebangs .

      for f in **/*.{py,c,t}; do
        # not only used in shebangs
        substituteAllInPlace "$f" '/bin/sh' '${stdenv.shell}'
      done

      for f in **/*.t; do
        substituteInPlace 2>/dev/null "$f" \
          --replace '*/hg:' '*/*hg*:' \${/* paths emitted by our wrapped hg look like ..hg-wrapped-wrapped */""}
          --replace '"$PYTHON" "$BINDIR"/hg' '"$BINDIR"/hg' ${/* 'hg' is a wrapper; don't run using python directly */""}
      done
    '';

    # This runs Mercurial _a lot_ of times.
    requiredSystemFeatures = [ "big-parallel" ];

    # Don't run tests if not-Linux or if cross-compiling.
    meta.broken = !stdenv.hostPlatform.isLinux || stdenv.buildPlatform != stdenv.hostPlatform;
  } ''
    addToSearchPathWithCustomDelimiter : PYTHONPATH "${mercurial}/${python.sitePackages}"

    unpackPhase
    cd "$sourceRoot"
    patchPhase

    cat << EOF > tests/blacklists/nix
    # tests enforcing "/usr/bin/env" shebangs, which are patched for nix
    test-run-tests.t
    test-check-shbang.t

    # unstable experimental/unsupported features
    # https://bz.mercurial-scm.org/show_bug.cgi?id=6633#c1
    test-git-interop.t

    # doesn't like the extra setlocale warnings emitted by our bash wrappers
    test-locale.t
    EOF

    export HGTEST_REAL_HG="${mercurial}/bin/hg"
    # extended timeout necessary for tests to pass on the busy CI workers
    export HGTESTFLAGS="--blacklist blacklists/nix --timeout 1800 -j$NIX_BUILD_CORES ${flags}"
    make check
    touch $out
  '';
in
  self.overridePythonAttrs (origAttrs: {
    passthru = origAttrs.passthru // rec {
      # withExtensions takes a function which takes the python packages set and
      # returns a list of extensions to install.
      #
      # for instance: mercurial.withExtension (pm: [ pm.hg-evolve ])
      withExtensions = f: let
        python = self.python;
        mercurialHighPrio = ps: (ps.toPythonModule self).overrideAttrs (oldAttrs: {
          meta = oldAttrs.meta // {
            priority = 50;
          };
        });
        plugins = (f python.pkgs) ++ [ (mercurialHighPrio python.pkgs) ];
        env = python.withPackages (ps: plugins);
      in stdenv.mkDerivation {
        pname = "${self.pname}-with-extensions";

        inherit (self) src version meta;

        buildInputs = self.buildInputs ++ self.propagatedBuildInputs;
        nativeBuildInputs = self.nativeBuildInputs;

        phases = [ "installPhase" "installCheckPhase" ];

        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin

          for bindir in ${lib.concatStringsSep " " (map (d: "${lib.getBin d}/bin") plugins)}; do
            for bin in $bindir/*; do
              ln -s ${env}/bin/$(basename $bin) $out/bin/
            done
          done

          ln -s ${self}/share $out/share

          runHook postInstall
        '';

        installCheckPhase = ''
          runHook preInstallCheck

          $out/bin/hg help >/dev/null || exit 1

          runHook postInstallCheck
        '';
      };

      tests = origAttrs.passthru.tests // {
        withExtensions = withExtensions (pm: [ pm.hg-evolve ]);
      };
    };
  })
