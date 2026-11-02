{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "goa";
  version = "3.30.0";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ppozf4SwN1JvZrTueRl3T/lY8Duo3Ja3VSoD7uzUgiA=";
  };
  vendorHash = "sha256-dXrDMFS76q7l//lOiSkA7G1nlELo/WV9mvXEHMsQAb0=";

  subPackages = [ "cmd/goa" ];

  meta = {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rushmorem ];
  };
})
