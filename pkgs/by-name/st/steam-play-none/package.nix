{ fetchFromGitHub
, stdenvNoCC
, lib
, bash
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "steam-play-none";
  version = "0-unstable-2022-12-15";
  src = fetchFromGitHub {
    owner = "Scrumplex";
    repo = "steam-play-none";
    rev = "42e38706eb37fdaaedbe9951d59ef44148fcacbf";
    hash = "sha256-sSHLrB5TlGMKpztTnbh5oIOhcrRd+ke2OUUbiQUqoh0=";
  };
  buildInputs = [ bash ];
  strictDeps = true;
  outputs = [ "out" "steamcompattool" ];
  installPhase = ''
    runHook preInstall

    # Make it impossible to add to an environment. You should use the appropriate NixOS option.
    # Also leave some breadcrumbs in the file.
    echo "${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    install -Dt $steamcompattool compatibilitytool.vdf toolmanifest.vdf
    install -Dt $steamcompattool -m755 launch.sh

    runHook postInstall
  '';

  meta = {
    description = ''
      Steam Play Compatibility Tool to run games as-is

      (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
    '';
    homepage = "https://github.com/Scrumplex/Steam-Play-None";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ matthewcroughan Scrumplex ];
    platforms = [ "x86_64-linux" ];
  };
})
