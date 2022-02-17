{ buildGoModule, fetchFromSourcehut, lib, scdoc }:
buildGoModule rec {
  pname = "hut";
  # No versions are listed upstream
  version = "0bcc6681";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "hut";
    # There are no tagged releases
    rev = "0bcc6681048938e5bb4f5fc836523e9b9ef5d993";
    sha256 = "sha256-hzXtFfrcgc0uKtSSHbE0cgFtpVtS/MjtGvAEdveIXZQ="; 
  };

  vendorSha256 = "sha256-zdQvk0M1a+Y90pnhqIpKxLJnlVJqMoSycewTep2Oux4=";

  nativeBuildInputs = [ scdoc ];
  
  postBuild = ''
    make doc/hut.1
  '';

  postInstall = ''
    install -Dpm 0644 doc/hut.1 -t $out/share/man1/
  '';
  meta = with lib; {
    description = "A CLI tool for sr.ht.";
    homepage = "https://git.sr.ht/~emersion/hut";
    license = licenses.gpl3;
    maintainers = with maintainers; [ CodeLongAndProsper90 ];
  };
}
