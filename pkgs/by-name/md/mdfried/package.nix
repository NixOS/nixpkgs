{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  chafa,
  fontconfig,
  glib,
  gnumake,
  gperf,
  libiconv,
  python3,
  unzip,
  writeShellScriptBin,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdfried";
  version = "0.22.4";

  src = fetchFromGitHub {
    owner = "benjajaja";
    repo = "mdfried";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zcn1C8mXwljJ3HtYgYBPyU9cVHvoNBUn7qjqx45wMhE=";
  };

  cargoHash = "sha256-Nt+oBl2HX/H/7j62VjaHrY29gpd2vouevBJO0W3AYAk=";

  buildFeatures = [ "pdf" ];

  # Prevent updateAutotoolsGnuConfigScripts from modifying mupdf's vendored
  # autotools files — doing so invalidates cargo's fingerprint for mupdf-sys
  # and causes a rebuild that fails on read-only cargoArtifacts files.
  updateAutotoolsGnuConfigScriptsPhase = "true";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook # for mupdf-sys bindgen
    gperf # for mupdf vendored Makefile
    python3 # for mupdf vendored Makefile
    unzip # for mupdf vendored docx_template build
    # mupdf-sys cp_r copies files from the read-only Nix store, preserving
    # mode 444. make then fails to regenerate headers. Wrap make to chmod first.
    (writeShellScriptBin "make" ''
      chmod -R u+w . 2>/dev/null || true
      exec ${lib.getExe gnumake} "$@"
    '')
  ];

  buildInputs = [
    chafa
    fontconfig.dev # for font-kit (mupdf dep)
    glib.dev # for glib-2.0.pc (mupdf needs glib.dev, chafa could do with just glib)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  CFLAGS_aarch64_apple_darwin = lib.optionalString stdenv.hostPlatform.isDarwin "-UTARGET_OS_MAC";
  CXXFLAGS_aarch64_apple_darwin = lib.optionalString stdenv.hostPlatform.isDarwin "-UTARGET_OS_MAC";

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Markdown viewer TUI for the terminal, with big text and image rendering";
    homepage = "https://github.com/benjajaja/mdfried";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ benjajaja ];
    platforms = lib.platforms.unix;
    mainProgram = "mdfried";
  };
})
