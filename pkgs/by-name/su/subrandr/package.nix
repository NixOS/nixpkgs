{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  freetype,
  harfbuzz,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "subrandr";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "afishhh";
    repo = "subrandr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ji1QQT+z9uuhOddNwwZV/mEx93NcWWw+dmIrWYp8+7s=";
  };

  cargoHash = "sha256-NTVgwPaK5URaG6rDWBnb9f06gHJeoq+d/k7k3Kae3o4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fontconfig
    freetype
    harfbuzz
  ];

  buildPhase = ''
    cargo xtask build --target "${stdenv.targetPlatform.rust.rustcTarget}"
  '';

  installPhase = ''
    cargo xtask install --prefix "$out" --target "${stdenv.targetPlatform.rust.rustcTarget}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/afishhh/subrandr";
    description = "Library for rendering SRV3 and WebVTT captions";
    platforms = lib.platforms.all;
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.artemist ];
  };
})
