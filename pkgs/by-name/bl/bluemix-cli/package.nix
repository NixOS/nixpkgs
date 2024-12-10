{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "bluemix-cli";
  version = "0.8.0";

  src =
    if stdenv.hostPlatform.system == "i686-linux" then
      fetchurl {
        name = "linux32-${version}.tar.gz";
        url = "https://clis.ng.bluemix.net/download/bluemix-cli/${version}/linux32";
        sha256 = "1ryngbjlw59x33rfd32bcz49r93a1q1g92jh7xmi9vydgqnzsifh";
      }
    else
      fetchurl {
        name = "linux64-${version}.tar.gz";
        url = "https://clis.ng.bluemix.net/download/bluemix-cli/${version}/linux64";
        sha256 = "056zbaca430ldcn0s86vy40m5abvwpfrmvqybbr6fjwfv9zngywx";
      }
    ;

  installPhase = ''
    install -m755 -D -t $out/bin bin/ibmcloud bin/ibmcloud-analytics
    install -m755 -D -t $out/bin/cfcli bin/cfcli/cf
    ln -sv $out/bin/ibmcloud $out/bin/bx
    ln -sv $out/bin/ibmcloud $out/bin/bluemix
    install -D -t "$out/share/bash-completion/completions" bx/bash_autocomplete
    install -D -t "$out/share/zsh/site-functions" bx/zsh_autocomplete
  '';

  meta = with lib; {
    description  = "Administration CLI for IBM BlueMix";
    homepage     = "https://console.bluemix.net/docs/cli/index.html";
    downloadPage = "https://console.bluemix.net/docs/cli/reference/bluemix_cli/download_cli.html#download_install";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license      = licenses.unfree;
    maintainers  = [ maintainers.tazjin maintainers.jensbin ];
    platforms    = [ "x86_64-linux" "i686-linux" ];
  };
}
