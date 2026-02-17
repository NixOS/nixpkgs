{
  lib,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,
  openssl,

  stdenv,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "steamfetch";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "unhappychoice";
    repo = "steamfetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZcalXsO12EeQqa7eXPlDaaAZUBw0s8be75nvV29lxAI=";
  };

  cargoHash = "sha256-bTmNvh5OpnC5hqyMbdUo9elvoyCroo+fq+WbnYUo1cQ=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  postInstall = ''
    install -Dm755 target/${stdenv.hostPlatform.rust.rustcTarget}/release/build/steamworks-sys-*/out/libsteam_api.so $out/lib/libsteam_api.so
  '';

  meta = {
    description = "Neofetch-like Steam stats grabber - display your profile in style";
    homepage = "https://github.com/unhappychoice/steamfetch";
    changelog = "https://github.com/unhappychoice/steamfetch/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.ryand56 ];
    mainProgram = "steamfetch";
  };
})
