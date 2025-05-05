{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "honeymarker";
  version = "0.2.1";
  vendorHash = "sha256-ZuDobjC/nizZ7G0o/zVTQmDfDjcdBhfPcmkhgwFc7VU=";

  src = fetchFromGitHub {
    owner = "honeycombio";
    repo = "honeymarker";
    rev = "v${version}";
    hash = "sha256-tiwX94CRvXnUYpiux94XhOj2abn1Uc+wjcDOmw79ab4=";
  };

  meta = with lib; {
    description = "provides a simple CRUD interface for dealing with per-dataset markers on honeycomb.io";
    homepage = "https://honeycomb.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.iand675 ];
  };
}
