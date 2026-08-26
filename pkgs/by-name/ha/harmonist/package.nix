{
  lib,
  stdenv,
  buildGoModule,
  fetchFromCodeberg,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "harmonist";
  version = "1.0.3";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "anaseto";
    repo = "harmonist";
    tag = "v${finalAttrs.version}";
    hash =
      # darwin's case-insensitive filesystem produces a different source hash because of map-d vs map-D
      # is this a correctness issue?
      if stdenv.hostPlatform.isDarwin then
        "sha256-yNPGoCvCdrmFaUjtA1p8pgPIC9ekIizhG6oMiYRFYGA="
      else
        "sha256-9cEKkvQze+hg4CwDe5epTpuQPevylwnSP5xQAVGJ/wQ=";
  };

  vendorHash = "sha256-wibNLDdykV2psOnJbMKu0EZSrrhKRxrN/OTWXmUz2FM=";

  ldflags = [
    "-s"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Stealth coffee-break roguelike game";
    mainProgram = "harmonist";
    longDescription = ''
      Harmonist is a stealth coffee-break roguelike game. The game has a heavy
      focus on tactical positioning, light and noise mechanisms, making use of
      various terrain types and cones of view for monsters. Aiming for a
      replayable streamlined experience, the game avoids complex inventory
      management and character building, relying on items and player
      adaptability for character progression.
    '';
    changelog = "https://codeberg.org/anaseto/harmonist/src/tag/v${finalAttrs.version}/CHANGES.md";
    homepage = "https://harmonist.tuxfamily.org/";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
})
