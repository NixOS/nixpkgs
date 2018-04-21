with import ../../.. {};

runCommand "gen-keys" {
    buildInputs = [ dropbear openssh ];
  }
  ''
    mkdir $out
    dropbearkey -t rsa -f $out/dropbear.priv -s 4096 | sed -n 2p > $out/dropbear.pub
    ssh-keygen -q -t rsa -b 4096 -N "" -f client
    mv client $out/openssh.priv
    mv client.pub $out/openssh.pub
  ''
