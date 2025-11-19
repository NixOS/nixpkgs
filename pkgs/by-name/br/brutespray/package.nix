{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  medusa,
}:

buildGoModule (finalAttrs: {
  pname = "brutespray";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "x90skysn3k";
    repo = "brutespray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-szW4Cvby93aWbdH4I/RbGVvPBuM11sJGLuZA4nP2Cb4=";
  };

  vendorHash = "sha256-NJV5lCjr9wNZAZYtO1jWpLW2otWutUSQKdvnKUiFtBo=";

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
