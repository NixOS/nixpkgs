{ stdenvNoCC
, lib
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "serious-sans";
  version = "unstable-2023-09-04";

  src = fetchFromGitHub {
    owner = "kaBeech";
    repo = finalAttrs.pname;
    rev = "a23f2b303fa3b1ec8788c5abba67b44ca5a3cc0a";
    hash = "sha256-sPb9ZVDTBaZHT0Q/I9OfP7BMYJXPBiKkebzKgUHNuZM=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/serious-sans
    cp SeriousSans/*/* $out/share/fonts/serious-sans

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/kaBeech/serious-sans";
    description = "A legible monospace font for playful professionals";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
    platforms = lib.platforms.all;
  };
})
