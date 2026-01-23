{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchurl,
  fetchpatch,
  autoPatchelfHook,
  makeWrapper,
  nix-update-script,
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
  version = "1.16.0";

  src = fetchurl {
    url = "https://github.com/renode/renode/releases/download/v${finalAttrs.version}/renode-${finalAttrs.version}.linux-dotnet.tar.gz";
    hash = "sha256-oNlTz5LBggPkjKM4TJO2UDKQdt2Ga7rBTdgyGjN8/zA=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  propagatedBuildInputs = [
    gtk-sharp-3_0
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,libexec/renode}

    mv * $out/libexec/renode
    mv .renode-root $out/libexec/renode

    makeWrapper "$out/libexec/renode/renode" "$out/bin/renode" \
      --prefix PATH : "$out/libexec/renode:${lib.makeBinPath [ dotnetCorePackages.runtime_8_0 ]}" \
      --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules" \
      --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ gtk3-x11 ]}" \
      --prefix PYTHONPATH : "${pythonLibs}" \
      --set LOCALE_ARCHIVE "${glibcLocales}/lib/locale/locale-archive"
    makeWrapper "$out/libexec/renode/renode-test" "$out/bin/renode-test" \
      --prefix PATH : "$out/libexec/renode:${lib.makeBinPath [ dotnetCorePackages.runtime_8_0 ]}" \
      --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules" \
      --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ gtk3-x11 ]}" \
      --prefix PYTHONPATH : "${pythonLibs}" \
      --set LOCALE_ARCHIVE "${glibcLocales}/lib/locale/locale-archive"

    substituteInPlace "$out/libexec/renode/renode-test" \
      --replace '$PYTHON_RUNNER' '${python3Packages.python}/bin/python3'

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
    platforms = [ "x86_64-linux" ];
  };
})
