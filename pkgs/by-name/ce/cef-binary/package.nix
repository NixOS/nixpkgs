{
  libcef,
}:

libcef.overrideAttrs (oldAttrs: {
  pname = "cef-binary";

  installPhase = ''
    runHook preInstall

    cp -r .. $out

    runHook postInstall
  '';
})
