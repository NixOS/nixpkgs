{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargotom";
  version = "2.3.13";

  src = fetchFromGitHub {
    owner = "frederik-uni";
    repo = "cargotom";
    # first commit with mit license
    # todo: use tag = finalAttrs.version after next release
    rev = "c55177d35cb6db05a52f4af6bf6836fd2f99035f";
    hash = "sha256-v9Fb7y9Oa7zpWYUXw9ltFLuMZOhrrt77cDj3/KUMWVs=";
  };

  cargoHash = "sha256-vEU6Y6bafP3y76l1xCj25BUfbEcGdxnARauz2o/jiE0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  # html2md sets crate-type = ["rlib", "dylib", "staticlib"]
  # this causes cargo to also create .so file which links to rustc
  # this causes nix to add rustc to closure bumping its size to 1.5G
  #
  # see https://gitlab.com/Kanedias/html2md/-/blob/master/Cargo.toml
  postInstall = ''
    rm $out/lib/libhtml2md.so
    rmdir $out/lib
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cargo.toml LSP";
    homepage = "https://github.com/frederik-uni/cargotom";
    changelog = "https://github.com/frederik-uni/cargotom/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ istudyatuni ];
  };
})
