{
  writeShellApplication,
  lib,
  gawk,
}:
writeShellApplication {
  name = "iptables-insert-before";
  text = builtins.readFile ./iptables-insert-before.sh;
  runtimeInputs = [ gawk ];
  bashOptions = [
    "errexit"
    "nounset"
    "pipefail"
    "errtrace"
    "functrace"
  ];
  derivationArgs = {
    version = "0.0.1";
  };
  meta = with lib; {
    homepage = "https://github.com/network-utilities";
    description = "Insert iptables rules before a target";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ S0AndS0 ];
    platforms = platforms.linux;
    # mainProgram = "bin/iptables-insert-before.sh";
  };
}
