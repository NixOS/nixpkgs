{ lib
, fetchFromGitHub
, buildGoModule
, btrfs-progs
, go-md2man
, installShellFiles
, util-linux
, nixosTests
}:

buildGoModule rec {
  pname = "containerd";
  version = "1.5.2";

  outputs = [ "out" "man" ];

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "containerd";
    rev = "v${version}";
    sha256 = "sha256-RDLAmPBjDHCx9al+gstUTrvKc/L0vAm8IEd/mvX5Als=";
  };

  vendorSha256 = "sha256-f+53pRifaYXjUxrN3YVg8JHGbIUsqZSehPxGTSxS6/s=";
  deleteVendor = true;

  nativeBuildInputs = [ go-md2man installShellFiles util-linux ];

  buildInputs = [ btrfs-progs ];

  buildFlags = [ "VERSION=v${version}" "REVISION=${src.rev}" ];

  BUILDTAGS = lib.optionals (btrfs-progs == null) [ "no_btrfs" ];

  buildPhase = ''
    patchShebangs .
    make binaries man $buildFlags
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
    maintainers = with maintainers; [ offline vdemeester ];
    platforms = platforms.linux;
  };
}
