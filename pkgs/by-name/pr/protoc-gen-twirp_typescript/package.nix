{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "protoc-gen-twirp_typescript";
  version = "unstable-2022-08-14";

  src = fetchFromGitHub {
    owner = "larrymyers";
    repo = "protoc-gen-twirp_typescript";
    rev = "535986b31881a214db3c04f122bcc96a2823a155";
    sha256 = "sha256-LfF/n96LwRX8aoPHzCRI/QbDmZR9yMhE5yGhFAqa8nA=";
  };

  proxyVendor = true;
  vendorHash = "sha256-UyxHa28SY60U8VeL7TbSTyscqN5T7tKGfuN2GIL6QIg";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Protobuf Plugin for Generating a Twirp Typescript Client";
    mainProgram = "protoc-gen-twirp_typescript";
    homepage = "https://github.com/larrymyers/protoc-gen-twirp_typescript";
    license = licenses.mit;
    maintainers = with maintainers; [
      jojosch
      dgollings
    ];
  };
}
