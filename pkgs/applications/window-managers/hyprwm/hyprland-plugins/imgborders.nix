{
  lib,
  fetchFromCodeberg,
  mkHyprlandPlugin,
  cmake,
  nix-update-script,
}:
mkHyprlandPlugin (finalAttrs: {
  pluginName = "imgborders";
  version = "1.0.1";

  src = fetchFromCodeberg {
    owner = "zacoons";
    repo = "imgborders";
    tag = finalAttrs.version;
    hash = "sha256-fCzz4gh8pd7J6KQJB/avYcS0Z7NYpxjznPMtOwypPSQ=";
  };

  nativeBuildInputs = [
    cmake
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv imgborders.so $out/lib/libimgborders.so

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://codeberg.org/zacoons/imgborders";
    description = "Add tiling image borders to windows!";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [
      mrdev023
    ];
  };
})
