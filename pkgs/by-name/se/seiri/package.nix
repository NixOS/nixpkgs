{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  fontconfig,
  libGL,
  libxkbcommon,
  vulkan-loader,
  wayland,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "seiri";
  version = "0.4.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tarolling";
    repo = "seiri";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8iptlPQQ5vYz2ZAlD/gcTmbpS1VKsf5qqozS7oaLdR8=";
  };

  cargoHash = "sha256-1Ri9+ZJpa/XWIj7iVer61v/boICIr9T7QOouOAAKj/0=";

  # Drop the GitHub update check after every run and the self-update flag
  postPatch = ''
    substituteInPlace src/main.rs \
      --replace-fail "use seiri_cli::update;" "" \
      --replace-fail "update::notify_if_update_available();" "" \
      --replace-fail "/// Update the binary to the latest GitHub release" \
        "/// Disabled; update seiri through Nix" \
      --replace-fail "return update::run_self_update(verbose);" \
        'return Err("self-update is disabled; update seiri through Nix".into());'
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fontconfig
    openssl
  ];

  # PNG export cannot find a system font through Core Text in the Darwin sandbox
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=tests::test_cpp_export_svg_and_png"
  ];

  # eframe loads the windowing and graphics libraries at runtime
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        libGL
        libxkbcommon
        vulkan-loader
        wayland
        libx11
        libxcursor
        libxi
        libxrandr
      ]
    } $out/bin/seiri-cli
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language-agnostic project visualization tool";
    homepage = "https://github.com/tarolling/seiri";
    changelog = "https://github.com/tarolling/seiri/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "seiri-cli";
  };
})
