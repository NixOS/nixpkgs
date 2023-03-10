{ lib, buildGoModule, installShellFiles, fetchFromGitHub, ffmpeg, ttyd, makeWrapper, pname, version, meta, src, vendorHash }:

buildGoModule rec {
  inherit pname version meta src vendorHash;

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  postInstall = ''
    wrapProgram $out/bin/vhs --prefix PATH : ${lib.makeBinPath [ ffmpeg ttyd ]}
    $out/bin/vhs man > vhs.1
    installManPage vhs.1
    installShellCompletion --cmd vhs \
      --bash <($out/bin/vhs completion bash) \
      --fish <($out/bin/vhs completion fish) \
      --zsh <($out/bin/vhs completion zsh)
  '';
}
