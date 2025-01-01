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
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZX2FSZz9q56zWPSHPvXUOf2lzBupjgdTXgWpH1SBJY8=";
  };

  vendorHash = "sha256-P0Qnfu/cqLveAwz9jf/wTXxkoh0jvazlE5C/PcUrWsA=";

  nativeBuildInputs = [ makeWrapper installShellFiles ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild.xcrun sigtool ];

  # clean fails with read only vendor dir
  postPatch = ''
    substituteInPlace Makefile \
      --replace 'binaries: clean' 'binaries:' \
      --replace 'codesign --entitlements vz.entitlements -s -' 'codesign --force --entitlements vz.entitlements -s -'
  '';

  # It attaches entitlements with codesign and strip removes those,
  # voiding the entitlements and making it non-operational.
  dontStrip = stdenv.hostPlatform.isDarwin;

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
