{ stdenv, toKodiAddon, addonDir, cmake, kodi, kodi-platform, libcec_platform }:
{ name ? "${attrs.pname}-${attrs.version}"
, namespace
, version
, extraNativeBuildInputs ? []
, extraBuildInputs ? []
, extraRuntimeDependencies ? []
, extraCMakeFlags ? []
, extraInstallPhase ? "", ... } @ attrs:
toKodiAddon (stdenv.mkDerivation ({
  name = "kodi-" + name;

  dontStrip = true;

  nativeBuildInputs = [ cmake ] ++ extraNativeBuildInputs;
  buildInputs = [ kodi kodi-platform libcec_platform ] ++ extraBuildInputs;

  inherit extraRuntimeDependencies;

  # disables check ensuring install prefix is that of kodi
  cmakeFlags = [
    "-DOVERRIDE_PATHS=1"
  ] ++ extraCMakeFlags;

  # kodi checks for addon .so libs existance in the addon folder (share/...)
  # and the non-wrapped kodi lib/... folder before even trying to dlopen
  # them. Symlinking .so, as setting LD_LIBRARY_PATH is of no use
  installPhase = let n = namespace; in ''
    runHook preInstall

    make install

    [[ -f $out/lib/addons/${n}/${n}.so ]] && ln -s $out/lib/addons/${n}/${n}.so $out${addonDir}/${n}/${n}.so || true
    [[ -f $out/lib/addons/${n}/${n}.so.${version} ]] && ln -s $out/lib/addons/${n}/${n}.so.${version} $out${addonDir}/${n}/${n}.so.${version} || true

    ${extraInstallPhase}

    runHook postInstall
  '';
} // attrs))
