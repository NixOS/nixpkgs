{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  addDriverRunpath,
  cacert,
  ffmpeg,
  libva,
  libvpl,
  ocl-icd,
  vulkan-loader,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ersatztv-next";
  version = "0.2.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ErsatzTV";
    repo = "next";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y2Q07NzlmtFxlY1oNeIyZCoVB92dIHCecjtleIbJwik=";
  };

  cargoHash = "sha256-YQ19V+KaD2bkB0ZJ4h2sre4jbeQUoDRcEvIrV7ZA8Ec=";

  nativeBuildInputs = [
    addDriverRunpath
    makeWrapper
  ];

  env.ETV_VERSION = finalAttrs.version;

  cargoBuildFlags = [ "--workspace" ];

  nativeCheckInputs = [
    cacert # reqwest can't build a client without system CAs
    ffmpeg
  ];
  cargoTestFlags = [ "--workspace" ];

  postInstall = ''
    rm $out/bin/gen-channel-config-schema $out/bin/gen-lineup-config-schema $out/bin/probe_capabilities
  '';

  # The *-sys crates dlopen these to probe hardware acceleration
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    for bin in $out/bin/*; do
      patchelf --add-rpath ${
        lib.makeLibraryPath [
          libva
          libvpl
          ocl-icd
          vulkan-loader
        ]
      } "$bin"
      addDriverRunpath "$bin"
      wrapProgram "$bin" --suffix PATH : ${lib.makeBinPath [ ffmpeg ]}
    done
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) ersatztv; };
  };

  meta = {
    description = "Streaming engine for ErsatzTV that transcodes playouts into live IPTV channels";
    homepage = "https://ersatztv.org/next-docs/";
    changelog = "https://github.com/ErsatzTV/next/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ font44 ];
    mainProgram = "ersatztv";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
