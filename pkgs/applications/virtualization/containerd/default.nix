{
  lib,
  fetchFromGitHub,
  buildGoModule,
  btrfs-progs,
  go-md2man,
  installShellFiles,
  util-linux,
  nixosTests,
  kubernetes,
}:

buildGoModule rec {
  pname = "containerd";
  version = "1.7.16";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "containerd";
    rev = "v${version}";
    hash = "sha256-OApJaH11iTvjW4gZaANSCVcxw/VHG7a/6OnYcUcHFME=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    go-md2man
    installShellFiles
    util-linux
  ];

  buildInputs = [ btrfs-progs ];

  BUILDTAGS = lib.optionals (btrfs-progs == null) [ "no_btrfs" ];

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    make binaries "VERSION=v${version}" "REVISION=${src.rev}"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm555 bin/* -t $out/bin
    installShellCompletion --bash contrib/autocomplete/ctr
    installShellCompletion --zsh --name _ctr contrib/autocomplete/zsh_autocomplete
    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) docker;
  } // kubernetes.tests;

  meta = with lib; {
    changelog = "https://github.com/containerd/containerd/releases/tag/${src.rev}";
    homepage = "https://containerd.io/";
    description = "A daemon to control runC";
    license = licenses.asl20;
    maintainers = with maintainers; [
      offline
      vdemeester
    ];
    platforms = platforms.linux;
  };
}
