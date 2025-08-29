{
  lib,
  stdenvNoCC,
  fetchzip,
  nix-update-script,
}:
stdenvNoCC.mkDerivation rec {
  pname = "0xproto";
  version = "2.500";

  src =
    let
      underscoreVersion = builtins.replaceStrings [ "." ] [ "_" ] version;
    in
    fetchzip {
      url = "https://github.com/0xType/0xProto/releases/download/${version}/0xProto_${underscoreVersion}.zip";
      hash = "sha256-AmD5lUV341222gu/cCLnKWO87mjPn7gFkeklrV3OlOs=";
      stripRoot = false;
    };

  # Exclude files in ZxProto/. The fonts are identical, with only the filenames changed.:
  # https://github.com/0xType/0xProto/pull/112
  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/fonts/opentype/ *.otf ./No-Ligatures/*-NL.otf
    install -Dm644 -t $out/share/fonts/truetype/ *.ttf ./No-Ligatures/*-NL.ttf
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Free and Open-source font for programming";
    homepage = "https://github.com/0xType/0xProto";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ edswordsmith ];
    platforms = lib.platforms.all;
  };
}
