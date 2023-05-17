{ lib
, buildGoModule
, installShellFiles
, fetchFromGitHub
, gitUpdater
, testers
, mods
}:

buildGoModule rec {
  pname = "mods";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-r7j7iMkfkFsohguu2vkhyxUbaMwJQURfUJrnC6yUCFI=";
  };

  vendorSha256 = "sha256-+0yGFCGd/9bIBjXYp8UPGqKum2di5O1ALMyDSxcVujg=";

  ldflags = [ "-s" "-w" "-X=main.version=${version}" ];

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = ".(rc|beta).*";
    };

    tests.version = testers.testVersion {
      package = mods;
      command = "mods --version";
      version = "${version}";
    };
  };

  meta = with lib; {
    description = "Tasty Bubble Mods! AI for the command line, built for pipelines";
    homepage = "https://github.com/charmbracelet/mods";
    changelog = "https://github.com/charmbracelet/mods/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ otavio ];
  };
}
