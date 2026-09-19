{
  lib,
  libarchive,
  fetchurl,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  name = "pak0.pak";
  version = "1.06";

  src = fetchurl {
    url = "https://github.com/Jason2Brownlee/QuakeOfficialArchive/raw/main/bin/quake106.zip";
    hash = "sha256-7GydNLGuAlKsAGYEW2YRp5GcKg14o6Ztk4eo9ZdVMjk=";
    meta.license = {
      url = "https://github.com/id-Software/Quake/raw/master/WinQuake/data/SLICNSE.TXT";
      free = false;
      redistributable = true;
    };
  };

  nativeBuildInputs = [ libarchive ];

  outputHash = "sha256-NanFXl5aKEoVmtKmLg6N7yPYKVYf4vVOtALbwKmpRq8=";

  unpackPhase = ''
    runHook preUnpack
    bsdtar xf "$src" resource.1
    bsdtar xf resource.1 ID1/PAK0.PAK
    runHook postUnpack
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    cp ID1/PAK0.PAK "$out"
    runHook postInstall
  '';

  # to be used in source port expressions
  passthru.id1 = stdenvNoCC.mkDerivation {
    pname = "quake-shareware-id1";
    version = "1.06";

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      install -Dm644 ${finalAttrs.finalPackage} "$out/id1/pak0.pak"
      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-jalaua2KY3J7ULVfPjHxKLvuUL3xyhwtEQfW3o1vqdc=";
  };

  meta = {
    description = "Quake episode 1, shareware";
    longDescription = ''
      Original shareware distribution of Quake episode 1.
      A Quake source port is required to play.
      If you wish to use mods or the full version of the game,
      you can symlink pak0.pak to your own quake folder.
    '';
    homepage = "https://bethesda.net/en/game/quake";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ axunes ];
  };
})
