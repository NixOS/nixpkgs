{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  substituteAll,
}:
buildGoModule rec {
  pname = "flottbot";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "target";
    repo = "flottbot";
    rev = version;
    hash = "sha256-Fv4ZBCQA7gwt11ULIiyFwn+QgoMNgu+1TM9yy2Jz7og=";
  };

  patches = [
    # patch out debug.ReadBuidlInfo since version information is not available with buildGoModule
    (substituteAll {
      src = ./version.patch;
      version = version;
      vcsHash = version; # Maybe there is a way to get the git ref from src? idk.
    })
  ];

  vendorHash = "sha256-wOUQKFd2Xm/2rvLw8kw8Ejbcq/JUvup/BzZs0fllBYY=";

  subPackages = [ "cmd/flottbot" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Chatbot framework written in Go";
    homepage = "https://github.com/target/flottbot";
    license = licenses.asl20;
    maintainers = with maintainers; [ bryanhonof ];
    sourceProvenance = [ sourceTypes.fromSource ];
    mainProgram = "flottbot";
    platforms = platforms.unix;
  };
}
