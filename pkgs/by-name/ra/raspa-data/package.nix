{
  lib,
  stdenvNoCC,
  raspa,
}:

stdenvNoCC.mkDerivation {
  pname = "raspa-data";
  inherit (raspa) version src;

  outputs = [
    "out"
    "doc"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/raspa"
    mv examples "$out/share/raspa"
    mkdir -p "$doc/share/raspa"
    mv -T "Docs" "$doc/share/raspa/doc"
    runHook postInstall
  '';

  # Keep the shebangs of the examples from being patched
  dontPatchShebangs = true;

  meta = {
    inherit (raspa.meta) homepage license maintainers;
    description = "Example packs and documentation of RASPA";
    outputsToInstall = [
      "out"
      "doc"
    ];
    platforms = lib.platforms.all;
  };
}
