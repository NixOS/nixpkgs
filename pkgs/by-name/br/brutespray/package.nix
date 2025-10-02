{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  medusa,
}:

buildGoModule (finalAttrs: {
  pname = "brutespray";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "x90skysn3k";
    repo = "brutespray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tws3BvVQSlGcBgiJ8Ho7V/KJjzoq3TEOiChqTzrMbiU=";
  };

  vendorHash = "sha256-Fe3W5rlKygw4z5bF+6xy5mv86wKcBuCf3nhtdtFWJPM=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/brutespray \
      --prefix PATH : ${lib.makeBinPath [ medusa ]}
    mkdir -p $out/share/brutespray
    cp -r wordlist $out/share/brutespray/wordlist
  '';

  meta = {
    homepage = "https://github.com/x90skysn3k/brutespray";
    description = "Tool to do brute-forcing from Nmap output";
    mainProgram = "brutespray";
    longDescription = ''
      This tool automatically attempts default credentials on found services
      directly from Nmap output.
    '';
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
