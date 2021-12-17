{ lib
, fetchFromGitHub
, buildGoPackage
, btrfs-progs
, go-md2man
, installShellFiles
, util-linux
, nixosTests
}:

buildGoPackage rec {
  pname = "containerd";
  version = "1.4.11";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "containerd";
    rev = "v${version}";
    sha256 = "sha256-mUagr1/LqTCFvshWuiSMxsqdRqjzogt2tZ0uwR7ZVAs=";
  };

  goPackagePath = "github.com/containerd/containerd";
  outputs = [ "out" "man" ];

  nativeBuildInputs = [ go-md2man installShellFiles util-linux ];

  buildInputs = [ btrfs-progs ];

  buildPhase = ''
    cd go/src/${goPackagePath}
    patchShebangs .
    make binaries man "VERSION=v${version}" "REVISION=${src.rev}"
  '';

  installPhase = ''
    install -Dm555 bin/* -t $out/bin
    installManPage man/*.[1-9]
    installShellCompletion --bash contrib/autocomplete/ctr
    installShellCompletion --zsh --name _ctr contrib/autocomplete/zsh_autocomplete
  '';

  passthru.tests = { inherit (nixosTests) docker; };

  meta = with lib; {
    homepage = "https://containerd.io/";
    description = "A daemon to control runC";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
