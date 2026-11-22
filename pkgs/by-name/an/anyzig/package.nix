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
  version = "2026_11_12";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "marler8997";
    repo = "anyzig";
    tag = "v${finalAttrs.version}";
    hash = "sha256-THFys3LpRGtp4Al6nWj+JgIC19mMeQ1Ug9oJDJ0oKE4=";
  };

  nativeBuildInputs = [ zig ];

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) version src;
    pname = "anyzig";
    fetchAll = true;
    hash = "sha256-PXCto7lmw3BgMC1E5GiQqQN1aa98z0xgqkku1UivdSM=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"

    # anyzig's build.zig needs to patch the standard library, so we point
    # ZIG_LIB_DIR to a writable copy taken from the zig package
    export ZIG_LIB_DIR="$NIX_BUILD_TOP/zig-lib"
    cp -r ${zig}/lib/zig "$ZIG_LIB_DIR"
    chmod -R +w "$ZIG_LIB_DIR"
  '';

  zigBuildFlags = [
    "-Dforce-version=v${finalAttrs.version}"
  ]
  ++ lib.optionals (anyzigExe != "zig") [ "install-${anyzigExe}" ];

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin zig-out/bin/${anyzigExe}
    runHook postInstall
  '';

  # versionCheckHook doesn't support multiple arguments
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/${anyzigExe} any version | grep -F 'v${finalAttrs.version}'
    runHook postInstallCheck
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
