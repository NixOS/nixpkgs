{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  writableTmpDirAsHomeHook,
  libGL,
  libX11,
  libxkbcommon,
  libxcb,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ferrishot";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "nik-rev";
    repo = "ferrishot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QnIHLkxqL/4s6jgIbGmzR5tqCjH7yJcfpx0AhdxqVKc=";
  };

  cargoHash = "sha256-TJWS8LzLTQSr+0uw0x38mNJrjYvMzr90URYI8UcRQqc=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # error: unable to open output file '/homeless-shelter/.cache/clang/ModuleCache/354UBE8EJRBZ3/Cocoa-31YYBL2V1XGQP.pcm': 'No such file or directory'
    writableTmpDirAsHomeHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libxcb
  ];

  postInstall =
    let
      runtimeDeps = [
        libGL
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        libX11
        libxkbcommon
        wayland
      ];
    in
    ''
      wrapProgram $out/bin/ferrishot \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDeps}"
    '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Screenshot app written in Rust";
    homepage = "https://github.com/nik-rev/ferrishot";
    changelog = "https://github.com/nik-rev/ferrishot/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "ferrishot";
  };
})
