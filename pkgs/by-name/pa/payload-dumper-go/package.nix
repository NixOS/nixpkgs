{
  lib,
  buildGoModule,
  fetchFromGitHub,
  xz,
}:

buildGoModule (finalAttrs: {
  pname = "payload-dumper-go";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "ssut";
    repo = "payload-dumper-go";
    tag = finalAttrs.version;
    hash = "sha256-A9WVPn/MeLTt1ySmN8Xge/Ye8BDhtETJstxB6mI5FFU=";
  };

  vendorHash = "sha256-hjVgIVOwci1IXaV+0AHgB36pMSgQsYi3A+9NIMsSz54=";

  buildInputs = [ xz ];

  meta = {
    description = "Android OTA payload dumper written in Go";
    homepage = "https://github.com/ssut/payload-dumper-go";
    changelog = "https://github.com/ssut/payload-dumper-go/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aleksana ];
    mainProgram = "payload-dumper-go";
  };
})
