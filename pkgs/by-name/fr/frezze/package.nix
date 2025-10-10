{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "frezze";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "AbelHristodor";
    repo = "frezze";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zjZOqw7LEgdN4knjDDDFghi81ZJhgFn06OZrUSrKtSg=";
  };

  cargoHash = "sha256-9oC14u/WTHUw3VGXsdZQDYN3jAR0Y+zig0ZRci+dl70=";

  __structuredAttrs = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  # Ship the SQL migrations that frezze applies at startup
  postInstall = ''
    mkdir -p $out/share/frezze
    cp -r migrations $out/share/frezze/
    wrapProgram $out/bin/frezze \
      --set-default MIGRATIONS_PATH $out/share/frezze/migrations
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Block developers from merging anything on GitHub";
    homepage = "https://github.com/AbelHristodor/frezze";
    changelog = "https://github.com/AbelHristodor/frezze/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "frezze";
  };
})
