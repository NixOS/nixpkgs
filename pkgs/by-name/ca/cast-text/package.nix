{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "cast-text";
  version = "0.1.3";
  src = fetchFromGitHub {
    owner = "piqoni";
    repo = "cast-text";
    tag = "v${version}";
    hash = "sha256-PU0haunPF2iAHehRT76wHXsdv5oWiBH7xVJUkQbr4QU=";
  };

  vendorHash = "sha256-rTrV8qzGHNNC8wTLJVerOHwFjjCGQmVuHOnBJxuYMAk=";

  meta = {
    description = "Zero latency, easy-to-use full-text news terminal reader";
    homepage = "https://github.com/piqoni/cast-text";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ darwincereska ];
  };
}
