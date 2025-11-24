{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "pspy";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "DominicBreuker";
    repo = "pspy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7R4Tp0Q7wjAuTDukiehtRZOcTABr0YTnvrod9Jdwjok=";
  };

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  # the various TestStart* tests defined in $src/internal/pspy/pspy_test.go
  # can in rare cases hit a race condition
  # ("Did not get message in time" or "Wrong message")
  checkFlags = [ "-skip=^TestStart" ];

  vendorHash = "sha256-mgAsy2ufMDNpeCXG/cZ10zdmzFoGfcpCzPWIABnvJWU=";

  meta = with lib; {
    description = "Monitor linux processes without root permissions";
    homepage = "https://github.com/DominicBreuker/pspy";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eleonora ];
    mainProgram = "pspy";
  };
})
