{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  medusa,
}:

buildGoModule (finalAttrs: {
  pname = "brutespray";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "x90skysn3k";
    repo = "brutespray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Da43ngdqRsJW8Ippbu1vZ1vT0ushwg3h/3Ep5BQmoR0=";
  };

  vendorHash = "sha256-zmNhYW+r5WBgv2sEZgnvTEO/yfqfQuHX26kvIwJ7ygs=";

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
