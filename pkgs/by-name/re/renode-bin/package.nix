{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchurl,
  fetchpatch,
  autoPatchelfHook,
  makeWrapper,
  nix-update-script,
  _7zz,
  glibcLocales,
  python3Packages,
  dotnetCorePackages,
  gtk-sharp-3_0,
  gtk3-x11,
  dconf,
}:

let
  pythonLibs =
    with python3Packages;
    makePythonPath [
      construct
      psutil
      pyyaml
      requests
      tkinter

      # from tools/csv2resd/requirements.txt
      construct

      # from tools/execution_tracer/requirements.txt
      pyelftools

      (robotframework.overrideDerivation (oldAttrs: {
        src = fetchFromGitHub {
          owner = "robotframework";
          repo = "robotframework";
          rev = "v6.1";
          hash = "sha256-l1VupBKi52UWqJMisT2CVnXph3fGxB63mBVvYdM1NWE=";
        };
        patches = (oldAttrs.patches or [ ]) ++ [
          (fetchpatch {
            # utest: Improve filtering of output sugar for Python 3.13+
            name = "python3.13-support.patch";
            url = "https://github.com/robotframework/robotframework/commit/921e352556dc8538b72de1e693e2a244d420a26d.patch";
            hash = "sha256-aSaror26x4kVkLVetPEbrJG4H1zstHsNWqmwqOys3zo=";
          })
        ];
      }))
    ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "renode";
  version = "1.16.1";

  src = fetchurl (
    {
      x86_64-linux = {
        url = "https://github.com/renode/renode/releases/download/v${finalAttrs.version}/renode-${finalAttrs.version}.linux-dotnet.tar.gz";
        hash = "sha256-YmKcqjMe1L1Ot6vhPuLkg0+8qnDeSS2zll+vpO3FaU8=";
      };
      aarch64-darwin = {
        url = "https://github.com/renode/renode/releases/download/v${finalAttrs.version}/renode-${finalAttrs.version}-dotnet.osx-arm64-portable.dmg";
        hash = "sha256-mbiuWJe4km7xeYaNOaUE/lKWVV3JyblzcY3fOrCRddk=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}")
  );

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ _7zz ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    gtk-sharp-3_0
  ];

  strictDeps = true;

  # The DMG extracts to Renode.app/; we want Contents/MacOS/ as the root
  sourceRoot = lib.optionalString stdenv.hostPlatform.isDarwin "Renode.app/Contents/MacOS";

  # The DMG uses APFS and contains symlinks that 7zz rejects by default
  unpackCmd = lib.optionalString stdenv.hostPlatform.isDarwin "7zz x -snld $curSrc";

  # The aarch64-darwin build is a self-contained .NET application;
  # stripping corrupts the bundled runtime
  dontStrip = stdenv.hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,libexec/renode}

    mv * $out/libexec/renode
    mv .renode-root $out/libexec/renode

    renodePath="$out/libexec/renode"
    wrapperArgs=(--prefix PYTHONPATH : "${pythonLibs}")
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Pre-extract the .NET single-file bundle at build time so nothing
    # is written at runtime
    bundleExtractDir=$out/libexec/renode/.dotnet-bundle
    DOTNET_BUNDLE_EXTRACT_BASE_DIR=$bundleExtractDir \
      $out/libexec/renode/renode --version > /dev/null 2>&1 || true
    wrapperArgs+=(--set DOTNET_BUNDLE_EXTRACT_BASE_DIR "$bundleExtractDir")
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    renodePath="$renodePath:${lib.makeBinPath [ dotnetCorePackages.runtime_8_0 ]}"
    wrapperArgs+=(
      --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules"
      --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ gtk3-x11 ]}"
      --set LOCALE_ARCHIVE "${glibcLocales}/lib/locale/locale-archive"
    )
  ''
  + ''
    makeWrapper "$out/libexec/renode/renode" "$out/bin/renode" \
      --prefix PATH : "$renodePath" \
      "''${wrapperArgs[@]}"
    makeWrapper "$out/libexec/renode/renode-test" "$out/bin/renode-test" \
      --prefix PATH : "$renodePath:${python3Packages.python}/bin" \
      "''${wrapperArgs[@]}"

    substituteInPlace "$out/libexec/renode/renode-test" \
      --replace-fail '$PYTHON_RUNNER' '${python3Packages.python}/bin/python3'

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Virtual development framework for complex embedded systems";
    homepage = "https://renode.io";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      otavio
      znaniye
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
  };
})
