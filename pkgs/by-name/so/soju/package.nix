{
  buildGoModule,
  fetchFromCodeberg,
  installShellFiles,
  lib,
  nixosTests,
  pam,
  scdoc,
  withModernCSqlite ? false,
  withPam ? false,
  withSqlite ? true,
}:
buildGoModule (finalAttrs: {
  pname = "soju";
  version = "0.11.0";

  src = fetchFromCodeberg {
    owner = "emersion";
    repo = "soju";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pen7Lb/aUWY67Y8KBCGfBkG1pX3sdQ8+D9L7xw8afaQ=";
  };

  vendorHash = "sha256-LiTr+ilKYRA3K93RjVGsmWm2jvImmt9YIYTZPtXv6cE=";

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  buildInputs = lib.optional withPam pam;

  ldflags = [
    "-s"
    "-w"
    "-X codeberg.org/emersion/soju/config.DefaultPath=/etc/soju/config"
    "-X codeberg.org/emersion/soju/config.DefaultUnixAdminPath=/run/soju/admin"
  ];

  tags =
    lib.optional (!withSqlite) "nosqlite"
    ++ lib.optional withModernCSqlite "moderncsqlite"
    ++ lib.optional withPam "pam";

  postBuild = ''
    make doc/soju.1 doc/sojuctl.1
  '';

  checkFlags = [
    "-skip TestPostgresMigrations"
  ];

  postInstall = ''
    installManPage doc/soju.1 doc/sojuctl.1
  '';

  passthru.tests.soju = nixosTests.soju;

  meta = {
    description = "User-friendly IRC bouncer";
    longDescription = ''
      soju is a user-friendly IRC bouncer. soju connects to upstream IRC servers
      on behalf of the user to provide extra functionality. soju supports many
      features such as multiple users, numerous IRCv3 extensions, chat history
      playback and detached channels. It is well-suited for both small and large
      deployments.
    '';
    homepage = "https://soju.im";
    changelog = "https://codeberg.org/emersion/soju/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      azahi
      malte-v
    ];
    mainProgram = "sojuctl";
  };
})
