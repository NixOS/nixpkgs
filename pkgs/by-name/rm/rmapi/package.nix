{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rmapi";
  version = "0.0.35";

  src = fetchFromGitHub {
    owner = "ddvk";
    repo = "rmapi";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-mRJH0fQ8e4igR7IwcJdvUhrZDXvpTt/Dac7Pc9p7ITw=";
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
      wamserma
    ];
    mainProgram = "rmapi";
  };
})
