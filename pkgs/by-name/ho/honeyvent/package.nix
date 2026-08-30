{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "honeyvent";
  version = "1.1.3";
  vendorHash = null;

  src = fetchFromGitHub {
    owner = "honeycombio";
    repo = "honeyvent";
    rev = "v${finalAttrs.version}";
    hash = "sha256-L8hM4JJDDfVv/0O8H3lcI0SRVjDMYC82HG/4WU6Vim8=";
  };

  meta = {
    description = "CLI for sending individual events to honeycomb.io";
    homepage = "https://honeycomb.io/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.iand675 ];
  };
})
