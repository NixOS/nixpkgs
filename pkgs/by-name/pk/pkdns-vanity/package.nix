{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pkdns-vanity";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "jphastings";
    repo = "pkdns-vanity";
    tag = finalAttrs.version;
    hash = "sha256-/P59HefwchprftyYEsLSAWFRCNN7VT8Y9DqBTwXpy4Y=";
  };

  vendorHash = "sha256-hocnLCzWN8srQcO3BMNkd2lt0m54Qe7sqAhUxVZlz1k=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "A generator for vanity PKDNS domain names";
    homepage = "https://github.com/jphastings/pkdns-vanity";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arikgrahl ];
    mainProgram = "pkdns-vanity";
  };
})
