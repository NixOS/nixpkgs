{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "bazel-gazelle";
  version = "0.45.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-gazelle";
    rev = "v${version}";
    hash = "sha256-ulfZPb3MRIOVt8M6XVuuGKmgOgcglJcWsscj2BiMTpY=";
  };

  vendorHash = null;

  doCheck = false;

  subPackages = [ "cmd/gazelle" ];

  meta = {
    homepage = "https://github.com/bazelbuild/bazel-gazelle";
    description = ''
      Gazelle is a Bazel build file generator for Bazel projects. It natively
      supports Go and protobuf, and it may be extended to support new languages
      and custom rule sets.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kalbasit ];
    mainProgram = "gazelle";
  };
}
