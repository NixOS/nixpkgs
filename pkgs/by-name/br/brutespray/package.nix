{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  medusa,
}:

buildGoModule (finalAttrs: {
  pname = "brutespray";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "x90skysn3k";
    repo = "brutespray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ckw5U0TAF8NI3B8jyk7iPJ8T+9YEwFxoa9dJqb7kygI=";
  };

  vendorHash = "sha256-bzyvh7Ty9kl/fZwxYGH2G60wZvp607/+KflaFiZgs60=";

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
