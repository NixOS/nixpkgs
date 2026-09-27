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
  version = "1.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JVBotelho";
    repo = "skewrun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FGEjAJnxROi+M7GVJdCkfYJCE8PnSjxw+3dw879Jezg=";
  };

  cargoHash = "sha256-Lh7CqwFjG1bR9kN0fhCE/FYAhO5wHvlBYxiBRxU/Xio=";

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
