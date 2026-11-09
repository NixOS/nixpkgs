{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_17,
  nix-update-script,
  anyzigExe ? "zig", # "zig" or "zls"
}:

let
  zig = zig_0_17;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "any${anyzigExe}";
  version = "2026_11_03";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "marler8997";
    repo = "anyzig";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ripM/SMZNvfRcQyq5hM+kcQH3yQik1WVmACAWhOK/eE=";
  };

  nativeBuildInputs = [ zig ];

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) version src;
    pname = "anyzig";
    hash = "sha256-UHKvzdYb7akR87WucYdCa/hlfo+KQxV8BSug7BbIkHk=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  zigBuildFlags = lib.optionals (anyzigExe != "zig") [ "install-${anyzigExe}" ];

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin zig-out/bin/${anyzigExe}
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Universal ${anyzigExe} executable that lets you run any version of ${anyzigExe}";
    homepage = "https://github.com/marler8997/anyzig";
    changelog = "https://github.com/marler8997/anyzig/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = anyzigExe;
  };
})
