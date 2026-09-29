{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  SDL2,
  SDL2_net,
  pkg-config,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opentyrian";
  version = "2.1.20260913";

  src = fetchFromGitHub {
    owner = "opentyrian";
    repo = "opentyrian";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zAYn8/JKGtjj3REuQ3WeeKlQ+ifuhwEF7m3ixg/5154=";
  };

  data = fetchzip {
    url = "https://camanis.net/tyrian/tyrian21.zip";
    hash = "sha256-q11Ygg56zoWKMPbS6Q8v4Tx/OLrmAT+R5RkfbRw0P64=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    SDL2
    SDL2_net
  ];

  enableParallelBuilding = true;

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postInstall = ''
    mkdir -p $out/share/games/tyrian
    cp -r $data/* $out/share/games/tyrian/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = ''Open source port of the game "Tyrian"'';
    mainProgram = "opentyrian";
    homepage = "https://github.com/opentyrian/opentyrian";
    license =
      with lib.licenses;
      AND [
        gpl2Plus # opentyrian
        unfree # First-party assets we bundle
      ];
    maintainers = with lib.maintainers; [
      iedame
      keenanweaver
    ];
  };
})
