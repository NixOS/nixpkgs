{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "helmsman";
<<<<<<< HEAD
  version = "4.0.4";
=======
  version = "4.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "mkubaczyk";
    repo = "helmsman";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    sha256 = "sha256-I2QBATunHjNwf4weHjYczpLNMX/8QsPe/ok0LTgZpmA=";
=======
    sha256 = "sha256-As0YjqMdPCgIzYWB1Wf3R11mwj6CglWZdvCRzlHDvkw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  subPackages = [ "cmd/helmsman" ];

<<<<<<< HEAD
  vendorHash = "sha256-i3qZ0OSV40oB8X3seixXMeji6CpcSiNK5wTbxF+TFpI=";

  doCheck = false;

  meta = {
    description = "Helm Charts (k8s applications) as Code tool";
    mainProgram = "helmsman";
    homepage = "https://github.com/Praqma/helmsman";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  vendorHash = "sha256-A5wFoOvBbjBv4F5Ul91GF9/l+8QXh9Xmmvhk5qNmems=";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    mainProgram = "helmsman";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      lynty
      sarcasticadmin
    ];
  };
})
