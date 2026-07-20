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
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-httpd";
  version = "0.26.0";

  env.RADICLE_VERSION = finalAttrs.version;

  src = fetchFromRadicle {
    seed = "seed.radicle.dev";
    repo = "z4V1sjrXqjvFdnCUbxPFqd5p4DtH5";
    tag = "releases/${finalAttrs.version}";
    nonConeMode = true;
    sparseCheckout = [
      "/crates"
      "/Cargo.toml"
      "/Cargo.lock"
    ];
    hash = "sha256-zSU8B5IwOEUS9d4Y/UWJ6eD0p3zvp0nWVgJmZ/kVB1Q=";
  };

  cargoHash = "sha256-rdW+WLkQ4UEn6hRZfgJhJkJWb7A26MayXVnVwAlLAG8=";

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
    updateScript = ./update.sh;
  };

  meta = {
    description = "Radicle JSON HTTP API Daemon";
    longDescription = ''
      A Radicle HTTP daemon exposing a JSON HTTP API that allows someone to browse local
      repositories on a Radicle node via their web browser.
    '';
    homepage = "https://radicle.dev";
    changelog = "https://radicle.network/nodes/seed.radicle.dev/rad:z4V1sjrXqjvFdnCUbxPFqd5p4DtH5/tree/CHANGELOG.md";
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
