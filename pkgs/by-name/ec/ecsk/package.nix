{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "ecsk";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "yukiarrr";
    repo = "ecsk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wCv3wyD2KM4Jzawd6Z4JFLCafsDp0W40ygbB05h7r0I=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-Eyqpc7GyG/7u/I4tStADQikxcbIatjeAJN9wUDgzdFY=";

  subPackages = [ "cmd/ecsk" ];

  meta = {
    description = "Interactively call Amazon ECS APIs, copy files between ECS and local, and view logs";
    license = lib.licenses.mit;
    mainProgram = "ecsk";
    homepage = "https://github.com/yukiarrr/ecsk";
    maintainers = with lib.maintainers; [ whtsht ];
  };
})
