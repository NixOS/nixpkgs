{
  lib,
  fetchFromGitHub,
  buildGoModule,
  gitUpdater,
}:
let
  pname = "cast-text";
  version = "0.1.3";
  src = fetchFromGitHub {
    owner = "piqoni";
    repo = "cast-text";
    rev = "v${version}";
    hash = "sha256-PU0haunPF2iAHehRT76wHXsdv5oWiBH7xVJUkQbr4QU=";
  };
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-rTrV8qzGHNNC8wTLJVerOHwFjjCGQmVuHOnBJxuYMAk=";

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Zero latency, easy-to-use full-text news terminal reader";
    homepage = "https://github.com/piqoni/cast-text";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.all;
  };
}
