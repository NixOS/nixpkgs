{
  stdenv,
  toKodiAddon,
  addonDir,
}:
{
  name ? "${attrs.pname}-${attrs.version}",
  namespace,
  sourceDir ? "",
  ...
}@attrs:
toKodiAddon (
  stdenv.mkDerivation (
    {
      name = "kodi-" + name;

      dontStrip = true;

      extraRuntimeDependencies = [ ];

      installPhase = ''
        runHook preInstall

        cd ./$sourceDir
        d=$out${addonDir}/${namespace}
        mkdir -p $d
        sauce="."
        [ -d ${namespace} ] && sauce=${namespace}
        cp -R "$sauce/"* $d

        runHook postInstall
      '';
    }
    // attrs
  )
)
