{
  lib,
  buildGoModule,
  fetchFromGitLab,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "obfs4";
  version = "0.7.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    # We don't use pname = lyrebird and we use the old obfs4 name as the first
    # will collide with lyrebird Gtk3 program.
    repo = "lyrebird";
    tag = "lyrebird-${finalAttrs.version}";
    hash = "sha256-JBYYMi80n9FlW1WNh1fa3G+stL4hX9XeJ2idLvtgylI=";
  };

  vendorHash = "sha256-isquplrmgtR8Mn5M+XNRdeGJHrAm7V7h1etVmVmN60I=";

  ldflags = [
    "-s"
    "-w"
    "-X main.lyrebirdVersion=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/lyrebird" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage doc/lyrebird.1
    ln -s $out/share/man/man1/{lyrebird,obfs4proxy}.1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^lyrebird-(\\d+\\.\\d+\\.\\d+)$" ];
  };

  meta = {
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
    changelog = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/lyrebird/-/blob/lyrebird-${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [
      bsd2
      bsd3
      gpl3
    ];
    maintainers = with lib.maintainers; [
      thoughtpolice
      defelo
    ];
    mainProgram = "lyrebird";
  };
})
