{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, makeWrapper
, writeScript
, glibcLocales
, python3Packages
, gtk-sharp-2_0
, gtk2-x11
, screen
, buildUnstable ? false
}:

let
  pythonLibs = with python3Packages; makePythonPath [
    construct
    psutil
    pyyaml
    requests
    robotframework
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "renode";
  version = "1.14.0";

  src = fetchurl {
    url = "https://builds.renode.io/renode-${finalAttrs.version}.linux-portable.tar.gz";
    hash = "sha256-1wfVHtCYc99ACz8m2XEg1R0nIDh9xP4ffV/vxeeEHxE=";
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

  passthru.updateScript =
    let
      versionRegex =
        if buildUnstable
        then "[0-9\.\+]+[^\+]*."
        else "[0-9\.]+[^\+]*.";
    in
    writeScript "${finalAttrs.pname}-updater" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts curl gnugrep gnused pup

      latestVersion=$(
        curl -sS https://builds.renode.io \
          | pup 'a text{}' \
          | egrep 'renode-${versionRegex}\.linux-portable\.tar\.gz' \
          | head -n1 \
          | sed -e 's,renode-\(.*\)\.linux-portable\.tar\.gz,\1,g'
      )

      update-source-version ${finalAttrs.pname} "$latestVersion" \
        --file=pkgs/by-name/re/${finalAttrs.pname}/package.nix \
        --system=x86_64-linux
    '';

  meta = {
    description = "Virtual development framework for complex embedded systems";
    homepage = "https://renode.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ otavio ];
    platforms = [ "x86_64-linux" ];
  };
})
