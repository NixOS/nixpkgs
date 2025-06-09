{
  replaceVarsWith,
  perl,
  shadow,
  util-linux,
  installShellFiles,
  configurationDirectory ? "/etc/nixos-containers",
  stateDirectory ? "/var/lib/nixos-containers",
  nixosTests,
}:
replaceVarsWith {
  name = "nixos-container";
  dir = "bin";
  isExecutable = true;
  src = ./nixos-container.pl;

  replacements = {
    perl = perl.withPackages (p: [ p.FileSlurp ]);
    su = "${shadow.su}/bin/su";

    inherit configurationDirectory stateDirectory util-linux;
  };

  passthru = {
    tests = {
      inherit (nixosTests)
        containers-imperative
        containers-ip
        containers-tmpfs
        containers-ephemeral
        containers-unified-hierarchy
        ;
    };
  };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd nixos-container \
      --bash ${./nixos-container-completion.sh} \
      --fish ${./nixos-container-completion.fish}
  '';

  meta.mainProgram = "nixos-container";
}
