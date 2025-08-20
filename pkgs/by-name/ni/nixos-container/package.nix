{ replaceVarsWith
, perl
, shadow
, util-linux
, configurationDirectory ? "/etc/nixos-containers"
, stateDirectory ? "/var/lib/nixos-containers"
, nixosTests
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

  postInstall = ''
    t=$out/share/bash-completion/completions
    mkdir -p $t
    cp ${./nixos-container-completion.sh} $t/nixos-container
  '';
  meta.mainProgram = "nixos-container";
}
