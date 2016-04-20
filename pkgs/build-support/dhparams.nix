{ runCommand, openssl, openssh }:

{ name, bits ? 2048, type ? "dhparam" }:

assert (builtins.elem type [ "dhparam" "moduli" ]);

builtins.getAttr type {
  dhparam = runCommand "dhparams-${name}.pem" {} ''
    ${openssl.bin}/bin/openssl dhparam -out $out ${toString bits}
  '';

  moduli = runCommand "ssh-moduli-${name}" {} ''
    ${openssh.bin}/bin/ssh-keygen -G moduli.candidates -b ${toString bits}
    ${openssh.bin}/bin/ssh-keygen -T $out -f moduli.candidates
  '';
}

