{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  git,
}:

let
  wrapperPath = lib.makeBinPath [
    git
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitnapped";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "Solexma";
    repo = "gitnapped";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DkKei7PnQnF+0odsPwJJ/pwO/yqdZGRrJQcdIMQ/3uI=";
  };

  cargoHash = "sha256-AIYDgjDYOwIi6KK5GzMF5UWYe9h7mGNONdwtlNygod4=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/gitnapped \
      --prefix PATH : ${wrapperPath}
  '';

  meta = {
    description = "Git commit timeline analyzer";
    homepage = "https://site.gitnapped.dev";
    maintainers = with lib.maintainers; [
      nicknb
    ];
    mainProgram = "gitnapped";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
  };
})
