{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "honeymarker";
  version = "0.2.13";
  vendorHash = "sha256-W6XVd68MS0ungMgam8jefYMVhyiN6/DB+bliFzs2rdk=";

  src = fetchFromGitHub {
    owner = "honeycombio";
    repo = "honeymarker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ywpxPYK7qn4LTSwQyJIZ3aTOmtl9k4D2DGO1VhBtRbc=";
  };

  meta = {
    description = "Simple CRUD interface for dealing with per-dataset markers on honeycomb.io";
    homepage = "https://honeycomb.io/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.iand675 ];
  };
})
