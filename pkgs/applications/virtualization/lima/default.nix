{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, qemu
, xcbuild
, sigtool
, makeWrapper
}:

buildGoModule rec {
  pname = "lima";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0yWQhyDSDGZT6K/SeVntTdqnDzyGD244+r5kG1MFh1c=";
  };

  vendorHash = "sha256-yA6qwnbRFR/V2Aaf53jLTejPKuNzbod2dVnLEQLoQkM=";

  nativeBuildInputs = [ makeWrapper installShellFiles ]
    ++ lib.optionals stdenv.isDarwin [ xcbuild.xcrun sigtool ];

  # clean fails with read only vendor dir
  postPatch = ''
    substituteInPlace Makefile \
      --replace 'binaries: clean' 'binaries:' \
      --replace 'codesign --entitlements vz.entitlements -s -' 'codesign --force --entitlements vz.entitlements -s -'
  '';

  # It attaches entitlements with codesign and strip removes those,
  # voiding the entitlements and making it non-operational.
  dontStrip = stdenv.isDarwin;

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
    changelog = "https://github.com/lima-vm/lima/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ anhduy ];
  };
}
