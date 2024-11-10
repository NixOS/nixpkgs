{ lib, buildGoModule, fetchFromGitLab, installShellFiles }:

buildGoModule rec {
  pname = "obfs4";
  version = "0.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    # We don't use pname = lyrebird and we use the old obfs4 name as the first
    # will collide with lyrebird Gtk3 program.
    repo = "lyrebird";
    rev = "lyrebird-${version}";
    hash = "sha256-aPALWvngC/BVQO73yUAykHvEb6T0DZcGMowXINDqhpQ=";
  };

  vendorHash = "sha256-iR3+ZMEF0SB3EoLTf2gtqTe3CQcjtDRhfwwbwGj3pXo=";

  ldflags = [ "-s" "-w" ];

  subPackages = [ "cmd/lyrebird" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage doc/lyrebird.1
    ln -s $out/share/man/man1/{lyrebird,obfs4proxy}.1
  '';

  meta = with lib; {
    description = "Circumvents censorship by transforming Tor traffic between clients and bridges";
    longDescription = ''
      Obfs4proxy is a tool that attempts to circumvent censorship by
      transforming the Tor traffic between the client and the bridge.
      This way censors, who usually monitor traffic between the client
      and the bridge, will see innocent-looking transformed traffic
      instead of the actual Tor traffic.  obfs4proxy implements the
      obfsucation protocols obfs2, obfs3, and obfs4.  It is written in
      Go and is compliant with the Tor pluggable transports
      specification, and its modular architecture allows it to support
      multiple pluggable transports.
    '';
    homepage = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/lyrebird";
    maintainers = with maintainers; [ thoughtpolice ];
    mainProgram = "lyrebird";
    changelog = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/lyrebird/-/raw/${src.rev}/ChangeLog";
    license = with lib.licenses; [ bsd2 bsd3 gpl3 ];
  };
}
