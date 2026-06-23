{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  makeWrapper,
  bat,
  fzf,
  xdg-utils,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "noogle-search";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "argosnothing";
    repo = "noogle-search";
    tag = "v${finalAttrs.version}";
    hash = "sha256-js3jBZsyukleQW2BwggfYUvKCdS8pBTjD6ysWyMUtpI=";
  };

  cargoHash = "sha256-axqFE5ZEiVP8PzFTtW5mbyyYcR4q9g3LX/0i6y+cgy8=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  postInstall = ''
    wrapProgram $out/bin/noogle-search \
      --prefix PATH : ${
        lib.makeBinPath [
          bat
          fzf
          xdg-utils
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Search Noogle functions with fzf";
    homepage = "https://github.com/argosnothing/noogle-search";
    license = lib.licenses.gpl3Plus;
    mainProgram = "noogle-search";
    maintainers = with lib.maintainers; [ argos_nothing ];
  };
})
