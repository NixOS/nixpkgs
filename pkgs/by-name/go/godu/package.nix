{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "godu";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "viktomas";
    repo = "godu";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z1LCPweaf8e/HWkSrRCiMYZl4F4dKo4/wDkWgY+eTvk=";
  };

  vendorHash = "sha256-8cZCeZ0gqxqbwB0WuEOFmEUNQd3/KcLeN0eLGfWG8BY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Utility helping to discover large files/folders";
    homepage = "https://github.com/viktomas/godu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rople380 ];
    mainProgram = "godu";
  };
})
