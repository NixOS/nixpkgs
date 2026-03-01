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
  version = "0.24.0";

  env.RADICLE_VERSION = finalAttrs.version;

  # You must update the radicle-explorer source hash when changing this.
  src = fetchFromRadicle {
    seed = "seed.radicle.xyz";
    repo = "z4V1sjrXqjvFdnCUbxPFqd5p4DtH5";
    tag = "releases/${finalAttrs.version}";
    sparseCheckout = [ "radicle-httpd" ];
    hash = "sha256-749hFe7GJz/YUmocW5MO7uKWLTo3W4wJYSXdIURcRtg=";
  };

  sourceRoot = "${finalAttrs.src.name}/radicle-httpd";

  cargoHash = "sha256-6uHukSsNnnk11tudFnNvNd+ZXmwGxMSYArsiaCaabWk=";

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
    homepage = "https://radicle.xyz";
    changelog = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:z4V1sjrXqjvFdnCUbxPFqd5p4DtH5/tree/radicle-httpd/CHANGELOG.md";
    # cargo.toml says MIT and asl20, LICENSE file says GPL3
    license = with lib.licenses; [
      gpl3Only
      mit
      asl20
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      gador
      lorenzleutgeb
      defelo
    ];
    mainProgram = "radicle-httpd";
  };
})
