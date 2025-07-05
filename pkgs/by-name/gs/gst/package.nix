{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  ghq,
}:

buildGoModule rec {
  pname = "gst";
  version = "5.0.5";

  src = fetchFromGitHub {
    owner = "uetchy";
    repo = "gst";
    rev = "v${version}";
    hash = "sha256-NhbGHTYucfqCloVirkaDlAtQfhWP2cw4I+t/ysvvkR0=";
  };

  vendorHash = "sha256-kGPg6NyhVfVOn0BFQY83/VYdpUjOqaf5I4bev0uhvUw=";

  doCheck = false;

  nativeBuildInputs = [
    gitMinimal
    ghq
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
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
    mainProgram = "gst";
  };
}
