{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "parinfer-rust-emacs";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "justinbarclay";
    repo = "parinfer-rust-emacs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JYKFfbfpkvBRxYUDw2d6DD1mO27OKzdquSOhBk0lXr0=";
  };

  cargoHash = "sha256-NUoBaaoPDpt19Avxyl6G9mmbcinm24aAvq6Z9Orb9a8=";

  meta = {
    description = "Emacs centric fork of parinfer-rust";
    mainProgram = "parinfer-rust";
    homepage = "https://github.com/justinbarclay/parinfer-rust-emacs";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ brsvh ];
  };
})
