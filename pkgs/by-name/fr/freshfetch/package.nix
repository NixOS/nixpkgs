{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "freshfetch";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "k4rakara";
    repo = "freshfetch";
    rev = "v${finalAttrs.version}";
    sha256 = "1l9zngr5l12g71j85iyph4jjri3crxc2pi9q0gczrrzvs03439mn";
  };

  cargoHash = "sha256-LKltHVig33zUSWoRgCb1BgeKiJsDnlYEuPfQfrnhafI=";

  # freshfetch depends on rust nightly features
  env.RUSTC_BOOTSTRAP = 1;

  meta = {
    description = "Fresh take on neofetch";
    homepage = "https://github.com/k4rakara/freshfetch";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "freshfetch";
  };
})
