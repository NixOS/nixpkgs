{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, qemu
, makeWrapper
}:

buildGoModule rec {
  pname = "lima";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-alE7fUVxJRkLMtdia5ruHxh9nlWIubM0J6iIrmpreRM=";
  };

  vendorSha256 = "sha256-Kb2R8USWOWRFMjQO3tjdl5UHOzzb2B3ld+5vO2gF3KY=";

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  # clean fails with read only vendor dir
  postPatch = ''
    substituteInPlace Makefile --replace 'binaries: clean' 'binaries:'
  '';

  buildPhase = ''
    runHook preBuild
    make "VERSION=v${version}" binaries
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r _output/* $out
    wrapProgram $out/bin/limactl \
      --prefix PATH : ${lib.makeBinPath [ qemu ]}
    installShellCompletion --cmd limactl \
      --bash <($out/bin/limactl completion bash) \
      --fish <($out/bin/limactl completion fish) \
      --zsh <($out/bin/limactl completion zsh)
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    USER=nix $out/bin/limactl validate examples/default.yaml
  '';

  meta = with lib; {
    homepage = "https://github.com/lima-vm/lima";
    description = "Linux virtual machines (on macOS, in most cases)";
    license = licenses.asl20;
    maintainers = with maintainers; [ anhduy ];
  };
}
