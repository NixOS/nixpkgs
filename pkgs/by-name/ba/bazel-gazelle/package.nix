{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "bazel-gazelle";
  version = "0.52.2";

  src = fetchFromGitHub {
    owner = "bazel-contrib";
    repo = "bazel-gazelle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0ovtpE9+YF9bql010CYOEngDIzRbmikSWuhV1+UEuf0=";
  };

  vendorHash = null;

  doCheck = false;

  subPackages = [ "cmd/gazelle" ];

  meta = {
    changelog = "https://github.com/bazel-contrib/bazel-gazelle/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/bazel-contrib/bazel-gazelle";
    description = ''
      Gazelle is a Bazel build file generator for Bazel projects. It natively
      supports Go and protobuf, and it may be extended to support new languages
      and custom rule sets.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kalbasit
      hythera
    ];
    mainProgram = "gazelle";
  };
})
