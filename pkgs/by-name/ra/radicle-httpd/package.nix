{
  asciidoctor,
  fetchFromRadicle,
  git,
  installShellFiles,
  lib,
  makeWrapper,
  man-db,
  rustPlatform,
  stdenv,
  xdg-utils,
  versionCheckHook,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-httpd";
  version = "0.30.0";

  env.RADICLE_VERSION = finalAttrs.version;

  src = fetchFromRadicle {
    # seed.radicle.dev currently doesn't update its canonical release tags correctly
    seed = "oak.radicle.garden";
    repo = "z4V1sjrXqjvFdnCUbxPFqd5p4DtH5";
    tag = "releases/httpd/${finalAttrs.version}";
    nonConeMode = true;
    sparseCheckout = [
      "/explorer/crates"
      "/explorer/Cargo.toml"
      "/explorer/Cargo.lock"
    ];
    rootDir = "explorer";
    hash = "sha256-V0sTvJ1KLjmOQsmp3QdWX+e4O7t3BlEOi+J71rDrbBw=";
  };

  cargoHash = "sha256-l2k6q7RtDChk9LDZngS+hh0srqNa6Z/KT2aOynmc9qs=";

  nativeBuildInputs = [
    asciidoctor
    installShellFiles
    makeWrapper
  ];
  nativeCheckInputs = [ git ];

  doCheck = stdenv.hostPlatform.isLinux;

  postInstall = ''
    for page in $(find -name '*.adoc'); do
      asciidoctor -d manpage -b manpage $page
      installManPage ''${page::-5}
    done
  '';

  postFixup = ''
    for program in $out/bin/* ;
    do
      wrapProgram "$program" \
        --prefix PATH : "${
          lib.makeBinPath [
            git
            man-db
            xdg-utils
          ]
        }"
    done
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    tests = { inherit (nixosTests) radicle; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Radicle JSON HTTP API Daemon";
    longDescription = ''
      A Radicle HTTP daemon exposing a JSON HTTP API that allows someone to browse local
      repositories on a Radicle node via their web browser.
    '';
    homepage = "https://radicle.dev";
    changelog = "https://radicle.network/nodes/seed.radicle.dev/rad:z4V1sjrXqjvFdnCUbxPFqd5p4DtH5/tree/explorer/CHANGELOG.md";
    # cargo.toml says MIT and asl20, LICENSE file says GPL3
    license = with lib.licenses; [
      gpl3Only
      mit
      asl20
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.radicle ];
    maintainers = with lib.maintainers; [ gador ];
    mainProgram = "radicle-httpd";
  };
})
