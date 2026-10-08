{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "httptap";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "monasticacademy";
    repo = "httptap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cn5u6q0r06SJp4uhF7j5K6yNZv8Q3WNxlDd5Vxmshhw=";
  };

  vendorHash = "sha256-yTtUt+kfDwN6W4caHCAYFjpYzhaqZUbLe+Nz7JKAXu8=";

  env.CGO_ENABLED = 0;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "View HTTP/HTTPS requests made by any Linux program";
    homepage = "https://github.com/monasticacademy/httptap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpetrucciani ];
    mainProgram = "httptap";
  };
})
