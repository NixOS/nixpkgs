{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "cocoon";
<<<<<<< HEAD
  version = "0.7.1";
=======
  version = "0.5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "haileyok";
    repo = "cocoon";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-kYBYdMoo7ToeljiW7AafL5cHzzeuaiL6MFE4Zw5Taqw=";
=======
    tag = finalAttrs.version;
    hash = "sha256-2zvbPhvYoKlQTZDjpo6LRr9DLKzSmcH0qnU1oJ+7k04=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-5WnME+AVrXfvHX2yPbFoL6QgZoCMAJmBj47OM7miOfc=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ATProtocol Personal Data Server written in Go with a SQLite block and blob store";
<<<<<<< HEAD
    changelog = "https://github.com/haileyok/cocoon/releases/v${finalAttrs.version}";
=======
    changelog = "https://github.com/haileyok/cocoon/releases/${finalAttrs.version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/haileyok/cocoon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "cocoon";
  };
})
