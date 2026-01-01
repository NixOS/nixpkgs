{
<<<<<<< HEAD
  buildGoModule,
  fetchFromGitea,
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
=======
  lib,
  buildGoModule,
  fetchFromGitea,
  installShellFiles,
  scdoc,
  nixosTests,
}:

buildGoModule rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "soju";
  version = "0.10.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "emersion";
    repo = "soju";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
=======
    rev = "v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-kOV7EFRr+Ca9bQ1bdDMNf1FiiniIHDebsf5SpbJshsI=";
  };

  vendorHash = "sha256-NP4njea0hcklxWFoxPQqrvyWExeRP/TOzUJcamRnx+s=";

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

<<<<<<< HEAD
  buildInputs = lib.optional withPam pam;

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ldflags = [
    "-s"
    "-w"
    "-X codeberg.org/emersion/soju/config.DefaultPath=/etc/soju/config"
    "-X codeberg.org/emersion/soju/config.DefaultUnixAdminPath=/run/soju/admin"
  ];

<<<<<<< HEAD
  tags =
    lib.optional (!withSqlite) "nosqlite"
    ++ lib.optional withModernCSqlite "moderncsqlite"
    ++ lib.optional withPam "pam";

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  postBuild = ''
    make doc/soju.1 doc/sojuctl.1
  '';

<<<<<<< HEAD
  checkFlags = [
    "-skip TestPostgresMigrations"
  ];
=======
  checkFlags = [ "-skip TestPostgresMigrations" ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  postInstall = ''
    installManPage doc/soju.1 doc/sojuctl.1
  '';

  passthru.tests.soju = nixosTests.soju;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "User-friendly IRC bouncer";
    longDescription = ''
      soju is a user-friendly IRC bouncer. soju connects to upstream IRC servers
      on behalf of the user to provide extra functionality. soju supports many
      features such as multiple users, numerous IRCv3 extensions, chat history
      playback and detached channels. It is well-suited for both small and large
      deployments.
    '';
    homepage = "https://soju.im";
<<<<<<< HEAD
    changelog = "https://codeberg.org/emersion/soju/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
=======
    changelog = "https://codeberg.org/emersion/soju/releases/tag/${src.rev}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      azahi
      malte-v
    ];
    mainProgram = "sojuctl";
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
