{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  lld,
  libsixel,
  versionCheckHook,
  nix-update-script,
}:
let
  inherit (stdenv.hostPlatform) isDarwin isx86_64;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "presenterm";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "presenterm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6ziPuWbPOsSwlnqVN1cKaOvxVk3axFnPBsnCIZz2iTg=";
  };

  nativeBuildInputs =
    lib.optionals isDarwin [
      makeBinaryWrapper
    ]
    ++ lib.optionals (isDarwin && isx86_64) [
      lld
    ];

  buildInputs = [
    libsixel
  ];

  buildFeatures = [
    "sixel"
  ];

  cargoHash = "sha256-UOPX5+RnnAStrsvBbL211m5NzYFjqbpIG/sdvoej1Rc=";

  env = lib.optionalAttrs (isDarwin && isx86_64) {
    NIX_CFLAGS_LINK = "-fuse-ld=lld";
  };

  checkFeatures = [
    "sixel"
  ];

  checkFlags = [
    # failed to load .tmpEeeeaQ: No such file or directory (os error 2)
    "--skip=external_snippet"
  ];

  # sixel-sys is dynamically linked to libsixel
  postInstall = lib.optionalString isDarwin ''
    wrapProgram $out/bin/presenterm \
      --prefix DYLD_LIBRARY_PATH : "${lib.makeLibraryPath [ libsixel ]}"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Terminal based slideshow tool";
    changelog = "https://github.com/mfontanini/presenterm/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/mfontanini/presenterm";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mikaelfangel ];
    mainProgram = "presenterm";
  };
})
