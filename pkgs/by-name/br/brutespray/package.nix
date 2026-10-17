{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  medusa,
}:

buildGoModule (finalAttrs: {
  pname = "brutespray";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "x90skysn3k";
    repo = "brutespray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O6bLzZaCNblPFLn1KStS/vdWEGg2+//+HpbCVxUJPMg=";
  };

  vendorHash = "sha256-yUMVPfZkZNxkby7Pg8s9knkG5Cw9FFhqLRN7qeP4agY=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/brutespray \
      --prefix PATH : ${lib.makeBinPath [ medusa ]}
    mkdir -p $out/share/brutespray
    cp -r wordlist $out/share/brutespray/wordlist
  '';

  meta = {
    description = "Tool to do brute-forcing from Nmap output";
    homepage = "https://github.com/x90skysn3k/brutespray";
    longDescription = ''
      This tool automatically attempts default credentials on found services
      directly from Nmap output.
    '';
    changelog = "https://github.com/x90skysn3k/brutespray/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "brutespray";
  };
})
