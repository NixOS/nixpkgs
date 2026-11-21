{
  buildNpmPackage,
  cacert,
  dart-sass,
  fetchFromGitHub,
  fetchpatch2,
  ffmpeg,
  lib,
  nix-update-script,
  nixosTests,
  nodejs_24,
  python3Packages,
  unar,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "bazarr";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "morpheus65535";
    repo = "bazarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5bhNbLfuL1wzraO3UypRRstC1+ULTaFVNJC++Qov6AE=";
  };

  patches = [
    (fetchpatch2 {
      name = "CVE-2026-130156-1.patch";
      url = "https://github.com/morpheus65535/bazarr/commit/4bd29252feebd0803e84cc3ce1bdd24c3a076ed4.patch?full_index=1";
      hash = "sha256-B3fumL5keOIaP5xh0NmABij/vI3vKnwpZ/4eKJ4vjNQ=";
    })
    (fetchpatch2 {
      name = "CVE-2026-130156-2.patch";
      url = "https://github.com/morpheus65535/bazarr/commit/d84777c61a34a90a37238cfb566e7e8cd102d303.patch?full_index=1";
      excludes = [ "tests/*" ];
      hash = "sha256-yAOe40qOBib+8PeQP0827rZm3wGGZvr4BjrbS4h7FNs=";
    })
    (fetchpatch2 {
      name = "CVE-2026-130156-3.patch";
      url = "https://github.com/morpheus65535/bazarr/commit/768a5259202ea7bfa5a395d6b39a9e8eac88f817.patch?full_index=1";
      excludes = [ "tests/*" ];
      hash = "sha256-nKw26Jvd8Tlf3fEUI2BTvNPRJqVPnMV923nibXrY26k=";
    })
    (fetchpatch2 {
      name = "GHSA-cf4p-fcvr-78pp-1.patch";
      url = "https://github.com/morpheus65535/bazarr/commit/884bdf345464e14bf743c4cdab6d26b356227257.patch?full_index=1";
      hash = "sha256-/IpbRGd3eju+lJel4Rfk01wtUGv5ZcESC2TcIJDqlhs=";
    })
    (fetchpatch2 {
      name = "GHSA-cf4p-fcvr-78pp-2.patch";
      url = "https://github.com/morpheus65535/bazarr/commit/e6c247edf7f9c94e6a953f9ed28c87ee975ee94e.patch?full_index=1";
      hash = "sha256-X4yNLjFsbsEKCjk/P8Njb/jTz3mT6Zg8NsxozxF86uw=";
    })
  ];

  dependencies = with python3Packages; [
    lxml
    numpy
    pillow
    psycopg2
    setuptools
    webrtcvad
  ];

  __structuredAttrs = true;
  dontBuild = true;
  dontWrapPythonPrograms = true;
  pyproject = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/bazarr/frontend
    cp -r bazarr bazarr.py custom_libs libs migrations $out/lib/bazarr/
    cp -r ${finalAttrs.passthru.frontend} $out/lib/bazarr/frontend/build

    printf '%s' "${finalAttrs.version}" > $out/lib/bazarr/VERSION

    printf '%s' "${
      lib.generators.toKeyValue { } {
        updatemethod = "External";
        updatemethodmessage = "Bazarr is managed by Nix. Update it through your system configuration.";
        packageversion = finalAttrs.version;
        packageauthor = "nixpkgs";
      }
    }" > $out/lib/bazarr/package_info

    makeWrapper ${lib.getExe python3Packages.python} $out/bin/bazarr \
      --add-flags $out/lib/bazarr/bazarr.py \
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          unar
        ]
      } \
      --prefix PYTHONPATH : ${python3Packages.makePythonPath finalAttrs.passthru.dependencies} \
      --set PYTHONNOUSERSITE true

    runHook postInstall
  '';

  postFixup = ''
    rm $out/lib/bazarr/libs/certifi/cacert.pem
    ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt $out/lib/bazarr/libs/certifi/cacert.pem
  '';

  passthru = {
    frontend = buildNpmPackage {
      inherit (finalAttrs) src version;
      pname = "${finalAttrs.pname}-frontend";

      sourceRoot = "${finalAttrs.src.name}/frontend";

      nodejs = nodejs_24;

      npmDepsHash = "sha256-uvUXk5+/WOfFRuBnC/SQOkau+0uIkJ4OTofMXckmwzw=";

      nativeBuildInputs = [ dart-sass ];

      # sass-embedded's bundled Dart compiler won't run in the sandbox; use nixpkgs' dart-sass.
      # https://github.com/sass/embedded-host-node/issues/334
      preBuild = ''
        substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
          --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["dart-sass"];'
      '';

      installPhase = ''
        runHook preInstall
        mv build $out
        runHook postInstall
      '';

      dontFixup = true;
    };

    tests.smoke-test = nixosTests.bazarr;

    updateScript = nix-update-script {
      extraArgs = lib.cli.toCommandLineGNU { } {
        subpackage = "frontend";
        use-github-releases = true;
      };
    };
  };

  meta = {
    description = "Subtitle manager for Sonarr and Radarr";
    homepage = "https://www.bazarr.media/";
    changelog = "https://github.com/morpheus65535/bazarr/releases/tag/${finalAttrs.src.tag}";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      connor-grady
      diogotcorreia
    ];
    mainProgram = "bazarr";
    platforms = lib.platforms.unix;
  };
})
