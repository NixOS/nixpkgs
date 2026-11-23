{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "rabtap";
  version = "1.46.0";

  src = fetchFromGitHub {
    owner = "jandelgado";
    repo = "rabtap";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-d70Oqv3CD38DOJ88ycVZOkjCX4a8siZhOFRtvfjuNZk=";
  };

  vendorHash = "sha256-zSICLdll9Hrn6VsRMxk4hxhzSnLel1aVM7OImuj2hn8=";

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
