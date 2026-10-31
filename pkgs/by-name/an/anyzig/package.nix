{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_17,
  fetchpatch,
  nix-update-script,
  anyzigExe ? "zig", # "zig" or "zls"
}:

let
  zig = zig_0_17;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "any${anyzigExe}";
  version = "2026_10_23";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "marler8997";
    repo = "anyzig";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aB3XGcyCQStxY2KDFxhcfmG5EzaBCBQ1AzkMPmRQ39s=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/marler8997/anyzig/commit/399706199ef1533a4021d374bb7ea146e05e58e1.patch";
      hash = "sha256-FNhHpoCGF/8csfzSahZCdLDN0sJjfLaG9LF3jtyL/JM=";
    })
  ];

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

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Universal ${anyzigExe} executable that lets you run any version of ${anyzigExe}";
    homepage = "https://github.com/marler8997/anyzig";
    changelog = "https://github.com/marler8997/anyzig/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = anyzigExe;
  };
})
