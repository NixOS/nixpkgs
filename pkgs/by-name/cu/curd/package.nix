{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  mpv,
  rofi,
  ueberzugpp,
  testers,
  curd,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "curd";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "Wraient";
    repo = "curd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yuHWluuJMWBr4wVRa8yEphpkef0YZrSilpCybMRS6o4=";
  };

  vendorHash = null;

  subPackages = [ "cmd/curd" ];

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/curd \
      --prefix PATH : ${
        lib.makeBinPath [
          mpv
          rofi
          ueberzugpp
        ]
      }
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = curd;
      command = ''
        export HOME=$(mktemp -d)
        curd -v
      '';
    };
  };

  meta = {
    description = "Watch anime in CLI with AniList Tracking, MAL Integration and Discord RPC";
    homepage = "https://github.com/Wraient/curd";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dageus ];
    mainProgram = "curd";
    platforms = lib.platforms.unix;
  };
})
