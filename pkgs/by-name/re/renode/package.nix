{ stdenv
, lib
, fetchFromGitHub
, fetchurl
, autoPatchelfHook
, makeWrapper
, nix-update-script
, glibcLocales
, python3Packages
, gtk-sharp-2_0
, gtk2-x11
, screen
}:

let
  pythonLibs = with python3Packages; makePythonPath [
    construct
    psutil
    pyyaml
    requests

    (robotframework.overrideDerivation (oldAttrs: {
      src = fetchFromGitHub {
        owner = "robotframework";
        repo = "robotframework";
        rev = "v6.0.2";
        hash = "sha256-c7pPcDgqyqWQtiMbLQbQd0nAgx4TIFUFHrlBVDNdr8M=";
      };
    }))
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "renode";
  version = "1.15.0";

  src = fetchurl {
    url = "https://github.com/renode/renode/releases/download/v${finalAttrs.version}/renode-${finalAttrs.version}.linux-portable.tar.gz";
    hash = "sha256-w3HKYctW1LmiAse/27Y1Gmz9hDprQ1CK7+TXIexCrkg=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  propagatedBuildInputs = [
    gtk2-x11
    gtk-sharp-2_0
    screen
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,libexec/renode}

    mv * $out/libexec/renode
    mv .renode-root $out/libexec/renode
    chmod +x $out/libexec/renode/*.so

    makeWrapper "$out/libexec/renode/renode" "$out/bin/renode" \
      --prefix PATH : "$out/libexec/renode" \
      --suffix LD_LIBRARY_PATH : "${gtk2-x11}/lib" \
      --set LOCALE_ARCHIVE "${glibcLocales}/lib/locale/locale-archive"

    makeWrapper "$out/libexec/renode/renode-test" "$out/bin/renode-test" \
      --prefix PATH : "$out/libexec/renode" \
      --prefix PYTHONPATH : "${pythonLibs}" \
      --suffix LD_LIBRARY_PATH : "${gtk2-x11}/lib" \
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
