{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "createrepo-rs";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "jamesarch";
    repo = "createrepo_rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-skeASya0ARGM6vcO5OVvKD20SGYSCws1RSnbnJDYIdI=";
  };

  cargoHash = "sha256-70KuriwRVWSRKpGMYF5kY0e1PA4lL7YSU5j8p7ojdgA=";

  __structuredAttrs = true;

  meta = {
    description = "Pure Rust RPM repository metadata generator — dnf/yum-compatible, zero FFI";
    homepage = "https://github.com/jamesarch/createrepo_rs";
    changelog = "https://github.com/jamesarch/createrepo_rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    mainProgram = "createrepo_rs";
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
