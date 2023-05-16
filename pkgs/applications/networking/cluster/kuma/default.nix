{ lib
, fetchFromGitHub
, buildGoModule
, coredns
, installShellFiles
, isFull ? false
, enableGateway ? false
, pname ? "kuma"
, components ? lib.optionals isFull [
    "kumactl"
    "kuma-cp"
<<<<<<< HEAD
=======
    "kuma-prometheus-sd"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "kuma-dp"
  ]
}:

buildGoModule rec {
<<<<<<< HEAD
  inherit pname;
  version = "2.3.1";
  tags = lib.optionals enableGateway [ "gateway" ];
=======
  inherit pname ;
  version = "1.8.1";
  tags = lib.optionals enableGateway ["gateway"];
  vendorSha256 = "sha256-69uXHvpQMeFwQbejMpfQPS8DDXJyVsnn59WUEJpSeng=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kumahq";
    repo = "kuma";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-BayfHBTTqgc0ArD6ux9HOqaZy0GrEpqgDa7zHZtiG2I=";
  };

  vendorHash = "sha256-St+jGks7ojKrgecmN7UJ9FjGrmjtgEKsunSY+4itUyA=";

  # no test files
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ] ++ lib.optionals isFull [ coredns ];
=======
    sha256 = "sha256-hNfgiMX3aMb8yjXjFKz73MczOeJyOI3Tna/NRSJBSzs=";
  };

  doCheck = false;

  nativeBuildInputs = [installShellFiles] ++ lib.optionals isFull [coredns];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preBuild = ''
    export HOME=$TMPDIR
  '';

  subPackages = map (p: "app/" + p) components;

  postInstall = lib.concatMapStringsSep "\n" (p: ''
    installShellCompletion --cmd ${p} \
      --bash <($out/bin/${p} completion bash) \
      --fish <($out/bin/${p} completion fish) \
      --zsh <($out/bin/${p} completion zsh)
  '') components + lib.optionalString isFull ''
    ln -sLf ${coredns}/bin/coredns $out/bin
  '';

  ldflags = let
    prefix = "github.com/kumahq/kuma/pkg/version";
  in [
    "-s" "-w"
    "-X ${prefix}.version=${version}"
    "-X ${prefix}.gitTag=${version}"
    "-X ${prefix}.gitCommit=${version}"
    "-X ${prefix}.buildDate=${version}"
  ];

  meta = with lib; {
    description = "Service mesh controller";
    homepage = "https://kuma.io/";
<<<<<<< HEAD
    changelog = "https://github.com/kumahq/kuma/blob/${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ zbioe ];
  };
}
