{
  lib,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,
  openssl,

  stdenvNoCC,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "steamfetch";
  version = "0.5.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "unhappychoice";
    repo = "steamfetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gi037/wqUfpohLK2FsFt7HqoJYa41wUDbbqnbuZwX0I=";
  };

  cargoHash = "sha256-RJdcVJ4CxKl/7xBzemRsQPhpxcXInyB4tS/EtYKRj4s=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  postInstall = ''
    mkdir -p $out/bin
    install -Dm644 -t $out/bin ./target/${stdenvNoCC.hostPlatform.rust.cargoShortTarget}/release/libsteam_api${stdenvNoCC.hostPlatform.extensions.sharedLibrary}
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
