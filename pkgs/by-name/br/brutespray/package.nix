{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  medusa,
}:

buildGoModule (finalAttrs: {
  pname = "brutespray";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "x90skysn3k";
    repo = "brutespray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oH7Gun/nKScv2buLwM6faiz9/3sl9l4JzkKbdTnGz0Q=";
  };

  vendorHash = "sha256-TBLjCXb1W5FHBrzxBI0/3NMuM9eCizLiz489jyZsEso=";

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
