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
  version = "1.6.8";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "containerd";
    rev = "v${version}";
    sha256 = "sha256-0UiPhkTWV61DnAF5kWd1FctX8i0sXaJ1p/xCMznY/A8=";
  };

  vendorSha256 = null;

  nativeBuildInputs = [ go-md2man installShellFiles util-linux ];

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

  passthru.tests = { inherit (nixosTests) docker; };

  meta = with lib; {
    homepage = "https://containerd.io/";
    description = "A daemon to control runC";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline vdemeester endocrimes zowoq ];
    platforms = platforms.linux;
  };
}
