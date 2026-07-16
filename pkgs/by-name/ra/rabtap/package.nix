{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "rabtap";
  version = "1.45.0";

  src = fetchFromGitHub {
    owner = "jandelgado";
    repo = "rabtap";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-1cNwNqbvF+i5GgzRD3RyFesGjA4/kJWFotPjJC+r/7g=";
  };

  vendorHash = "sha256-fp605VqspavEFQESP7yY6VG80ZpV6h33uhj2hoQiDKk=";

  ldflags = [
    "-X main.BuildVersion=v${finalAttrs.version}"
  ];

  meta = {
    description = "RabbitMQ wire tap and swiss army knife";
    license = lib.licenses.gpl3Only;
    homepage = "https://github.com/jandelgado/rabtap";
    maintainers = [ ];
  };
})
