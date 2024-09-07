{ stdenv
, lib
, fetchFromGitHub
, fetchurl
, autoPatchelfHook
, makeWrapper
, nix-update-script
, glibcLocales
, python3Packages
, dotnetCorePackages
, gtk-sharp-3_0
, gtk3-x11
, dconf
}:

let
  pythonLibs = with python3Packages; makePythonPath [
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
    }))
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "renode";
  version = "1.15.2";

  src = fetchurl {
    url = "https://github.com/renode/renode/releases/download/v${finalAttrs.version}/renode-${finalAttrs.version}.linux-dotnet.tar.gz";
    hash = "sha256-4W6/s2XYKj4q31VLz5MohaMdv4rLTaQHCx6AoWxHTvo=";
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
    maintainers = with lib.maintainers; [ otavio ];
    platforms = [ "x86_64-linux" ];
  };
})
