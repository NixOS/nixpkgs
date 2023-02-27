{ lib
, buildGoModule
, fetchFromGitHub
, git
, ghq
}:

buildGoModule rec {
  pname = "gst";
  version = "5.0.5";

  src = fetchFromGitHub {
    owner = "uetchy";
    repo = "gst";
    rev = "v${version}";
    sha256 = "07cixz5wlzzb4cwcrncg2mz502wlhd3awql5js1glw9f6qfwc5in";
  };

  vendorSha256 = "0k5xl55vzpl64gwsgaff92jismpx6y7l2ia0kx7gamd1vklf0qwh";

  doCheck = false;

  nativeBuildInputs = [
    git
    ghq
  ];

  ldflags = [
    "-s" "-w" "-X=main.Version=${version}"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    if [[ "$("$out/bin/${pname}" --version)" == "${pname} version ${version}" ]]; then
      export HOME=$(mktemp -d)
      git config --global user.name "Test User"
      git config --global user.email "test@example.com"
      git config --global init.defaultBranch "main"
      git config --global ghq.user "user"
      ghq create test > /dev/null 2>&1
      touch $HOME/ghq/github.com/user/test/SmokeTest
      $out/bin/${pname} list | grep SmokeTest > /dev/null
      echo '${pname} smoke check passed'
    else
      echo '${pname} smoke check failed'
      return 1
    fi
  '';

  meta = {
    description = "Supercharge your ghq workflow";
    homepage = "https://github.com/uetchy/gst";
    maintainers = with lib.maintainers; [ _0x4A6F ];
    license = lib.licenses.asl20;
  };
}
