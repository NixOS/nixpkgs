{ citrix_workspace, extraCerts ? [], symlinkJoin }:

let

  mkCertCopy = certPath:
    "cp ${certPath} $out/opt/citrix-icaclient/keystore/cacerts/";

in

if builtins.length extraCerts == 0 then citrix_workspace else symlinkJoin {
  name = "citrix-with-extra-certs-${citrix_workspace.version}";
  paths = [ citrix_workspace ];

  postBuild = ''
    ${builtins.concatStringsSep "\n" (map mkCertCopy extraCerts)}

    sed -i -E "s,-icaroot (.+citrix-icaclient),-icaroot $out/opt/citrix-icaclient," $out/bin/wfica
  '';
}
