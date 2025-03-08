with import ../../.. { };

runCommand "gen-keys"
  {
    buildInputs = [ openssh ];
  }
  ''
    mkdir $out
    ssh-keygen -q -t ed25519 -N "" -f $out/ssh_host_ed25519_key
    ssh-keygen -q -t ed25519 -N "" -f $out/id_ed25519
  ''
