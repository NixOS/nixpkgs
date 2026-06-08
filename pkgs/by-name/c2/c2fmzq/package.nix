{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "c2FmZQ";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "c2FmZQ";
    repo = "c2FmZQ";
    rev = "v${finalAttrs.version}";
    hash = "sha256-O4/V8fFiTfqTiJWPwEsdigdeKBmwGGo43ZvJXPcVRlE=";
  };

  ldflags = [
    "-s"
    "-w"
  ];

  sourceRoot = "${finalAttrs.src.name}/c2FmZQ";

  vendorHash = "sha256-B1kHtDHnviU60WEfmASMX69nyEepeeBdMZVtbcmZ9z4=";

  subPackages = [
    "c2FmZQ-client"
    "c2FmZQ-server"
  ];

  passthru.tests = { inherit (nixosTests) c2fmzq; };

  meta = {
    description = "Securely encrypt, store, and share files, including but not limited to pictures and videos";
    homepage = "https://github.com/c2FmZQ/c2FmZQ";
    license = lib.licenses.gpl3Only;
    mainProgram = "c2FmZQ-server";
    maintainers = with lib.maintainers; [ hmenke ];
    platforms = lib.platforms.linux;
  };
})
