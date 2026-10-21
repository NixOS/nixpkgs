{
  lib,
  fetchFromGitHub,
  libfaketime,
  makeBinaryWrapper,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "skewrun";
  version = "1.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JVBotelho";
    repo = "skewrun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C4LF2am3gnQb+k9cdfB2xcszZ5imRBwz0ldP0gjfXRs=";
  };

  cargoHash = "sha256-hGJvirVLtP1ondLxJuyfiV7Y0+pGt8Pu3lzLAhRYtoo=";

  buildInputs = [
    libfaketime
    makeBinaryWrapper
  ];

  postFixup = ''
    wrapProgram $out/bin/skewrun --prefix PATH : "${
      lib.makeBinPath [
        libfaketime
      ]
    }"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Active Directory time discovery toolkit";
    homepage = "https://github.com/JVBotelho/skewrun";
    changelog = "https://github.com/JVBotelho/skewrun/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "skewrun";
  };
})
