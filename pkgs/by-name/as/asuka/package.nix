{
  lib,
  rustPlatform,
  fetchFromSourcehut,
  pkg-config,
  ncurses,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "asuka";
  version = "0.8.5";

  src = fetchFromSourcehut {
    owner = "~julienxx";
    repo = "asuka";
    tag = version;
    hash = "sha256-+rj6P3ejc4Qb/uqbf3N9MqyqDT7yg9JFE0yfW/uzd6M=";
  };

  cargoHash = "sha256-aNHkhcvOdK6sf6nWxCNPxcktYhrnmLdMrLqWb/1QBQ4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    ncurses
    openssl
  ];

  meta = {
    description = "Gemini Project client written in Rust with NCurses";
    mainProgram = "asuka";
    homepage = "https://git.sr.ht/~julienxx/asuka";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
