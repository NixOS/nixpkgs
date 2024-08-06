{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "bitrise";
  version = "2.19.0";

  src = fetchFromGitHub {
    owner = "bitrise-io";
    repo = "bitrise";
    rev = version;
    hash = "sha256-VjuDeRl/rqA7bdhn9REdxdjRon5WxHkFIveOYNpQqa8=";
  };

  doCheck = false; # many tests rely on writing to $HOME/.bitrise

  vendorHash = null;
  ldflags = [
    "-X github.com/bitrise-io/bitrise/version.Commit=${src.rev}"
    "-X github.com/bitrise-io/bitrise/version.BuildNumber=0"
  ];
  CGO_ENABLED = 0;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    changelog = "https://github.com/bitrise-io/bitrise/releases/tag/${src.rev}";
    description = "Bitrise runner CLI - run your automations on your Mac or Linux machine";
    homepage = "https://bitrise.io";
    license = lib.licenses.mit;
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "bitrise";
    maintainers = with maintainers; [ ofalvai ];
  };
}
