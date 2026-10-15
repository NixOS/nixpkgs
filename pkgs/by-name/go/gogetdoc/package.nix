{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gogetdoc-unstable";
  version = "2019-02-28";
  rev = "b37376c5da6aeb900611837098f40f81972e63e4";

  vendorHash = null;

  doCheck = false;

  src = fetchFromGitHub {
    inherit rev;

    owner = "zmb3";
    repo = "gogetdoc";
    hash = "sha256-mQIpy3ULzKbvvCplCjrwYzOl9VcqozuAAQF20UH75Ow=";
  };

  meta = {
    description = "Gets documentation for items in Go source code";
    mainProgram = "gogetdoc";
    homepage = "https://github.com/zmb3/gogetdoc";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kalbasit ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
