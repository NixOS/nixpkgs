{
  buildGoModule,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "pspy";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "DominicBreuker";
    repo = "pspy";
    tag = "v${finalAttrs.version}";

    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse HEAD > $out/.git_head
      rm -rf $out/.git
    '';

    hash = "sha256-CPWoKxmjlGYP2kAC+LscOtrPpUjzpRoGTeohlw0mmh4=";
  };

  vendorHash = "sha256-mgAsy2ufMDNpeCXG/cZ10zdmzFoGfcpCzPWIABnvJWU=";

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  preBuild = ''
    ldflags+=" -X main.commit=$(<.git_head)"
  '';

  # the various TestStart* tests defined in $src/internal/pspy/pspy_test.go
  # can in rare cases hit a race condition
  # ("Did not get message in time" or "Wrong message")
  checkFlags = [ "-skip=^TestStart" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--help";
  doInstallCheck = true;

  meta = with lib; {
    description = "Monitor linux processes without root permissions";
    homepage = "https://github.com/DominicBreuker/pspy";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eleonora ];
    mainProgram = "pspy";
  };
})
