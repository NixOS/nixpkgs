{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "appimage-thumbnailer";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "kem-a";
    repo = "appimage-thumbnailer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dbJhIP2SMRLjr3M+hfvjptS8qlj7hE/aY8l4Wm9vImw=";
  };

  cargoHash = "sha256-0yUSctFqxCPuu+mu7WzWNUz9/SHbTqvlzZd/sr5+rCg=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zstd ];

  postInstall = ''
    mkdir -p $out/share/thumbnailers
    substitute $src/appimage-thumbnailer.thumbnailer.in \
      $out/share/thumbnailers/appimage-thumbnailer.thumbnailer \
      --replace-fail @EXEC_PATH@ "$out/bin/appimage-thumbnailer" \
      --replace-fail @TRYEXEC_PATH@ "$out/bin/appimage-thumbnailer"
  '';

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "freedesktop.org thumbnailer for AppImages";
    homepage = "https://github.com/kem-a/appimage-thumbnailer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MuntasirSZN ];
    platforms = lib.platforms.linux;
    mainProgram = "appimage-thumbnailer";
  };
})
