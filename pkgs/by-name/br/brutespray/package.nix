{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  medusa,
}:

buildGoModule (finalAttrs: {
  pname = "brutespray";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "x90skysn3k";
    repo = "brutespray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3CDvsYCiVuWr+Hp2NSzecmHl69Xf9Mcl1umqKW09OlQ=";
  };

  vendorHash = "sha256-odRe6Jd0MIOyahoMfZJgSbv+AHeUUvWLeENaQFmT9R4=";

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
