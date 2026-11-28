{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  medusa,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "brutespray";
  version = "2.7.9";

  src = fetchFromGitHub {
    owner = "x90skysn3k";
    repo = "brutespray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Unmqn/uj0MAefb90Q4D3BHz/4PayjWxEFxj3VSdzv9Y=";
  };

  vendorHash = "sha256-4+AkzV6jUCNVyZXc8ldtHi6alhuoFXaiDLPBC+bP81U=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/brutespray \
      --prefix PATH : ${lib.makeBinPath [ medusa ]}
    mkdir -p $out/share/brutespray
    cp -r wordlist $out/share/brutespray/wordlist
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to do brute-forcing from Nmap output";
    homepage = "https://github.com/x90skysn3k/brutespray";
    longDescription = ''
      This tool automatically attempts default credentials on found services
      directly from Nmap output.
    '';
    changelog = "https://github.com/x90skysn3k/brutespray/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
    mainProgram = "brutespray";
  };
})
