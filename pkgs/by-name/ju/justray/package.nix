{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "justray";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "luynrs";
    repo = "justray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ciu9pwfL29AabxrOzF5ztq5vk3qk4a0/NwX9rUO/6Ao=";
  };

  vendorHash = "sha256-K3IquEOFkc9E3E6xZTeZhMvz/2oWDz8oa6R4YHs/wsk=";
  proxyVendor = true;

  subPackages = [ "cmd/justray" "cmd/justrayd" ];
  tags = [ "with_quic" "with_utls" "with_gvisor" "with_grpc" ];
  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/luynrs/justray/internal/shared/version.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "A modern VPN client that lives in your terminal";
    homepage = "https://github.com/luynrs/justray";
    license = lib.licenses.gpl3Only;
    mainProgram = "justray";
    platforms = lib.platforms.linux;
  };
})
