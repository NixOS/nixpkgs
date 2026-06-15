{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "createrepo-rs";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "jamesarch";
    repo = "createrepo_rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4y29y0xvmOngkTt2P6+UZxxH1SQ2taAT4TSbuALkj34=";
  };

  cargoHash = "sha256-70KuriwRVWSRKpGMYF5kY0e1PA4lL7YSU5j8p7ojdgA=";

  __structuredAttrs = true;

  meta = {
    description = "Pure Rust RPM repository metadata generator — dnf/yum-compatible, zero FFI";
    homepage = "https://github.com/jamesarch/createrepo_rs";
    changelog = "https://github.com/jamesarch/createrepo_rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    mainProgram = "createrepo_rs";
    maintainers = with lib.maintainers; [ jamesarch ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
