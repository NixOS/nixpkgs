{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rmapi";
  version = "0.0.34";

  src = fetchFromGitHub {
    owner = "ddvk";
    repo = "rmapi";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-g7KFLa+VBkubzdrgMFDVvAuscw41nyfHd7DWvh3S+NU=";
  };

  vendorHash = "sha256-Qisfw+lCFZns13jRe9NskCaCKVj5bV1CV8WPpGBhKFc=";

  doCheck = false;

  meta = {
    description = "Go app that allows access to the ReMarkable Cloud API programmatically";
    homepage = "https://github.com/ddvk/rmapi";
    changelog = "https://github.com/ddvk/rmapi/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      nickhu
      boltzmannrain
    ];
    mainProgram = "rmapi";
  };
})
