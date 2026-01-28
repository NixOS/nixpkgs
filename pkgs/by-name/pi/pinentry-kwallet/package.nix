{
  lib,
  runCommandLocal,
  kwalletcli,
}:
let
  bin = "pinentry-kwallet";
  bin' = lib.getExe' kwalletcli bin;
in
runCommandLocal bin
  {
    pname = "pinentry-kwallet";
    inherit (kwalletcli) version;
    meta = {
      description = "Pinentry program for GnuPG that uses KWallet to store passphrases";
      # Note: this meta value is why another package is required. The module will execute the mainProgram as pinentry.
      mainProgram = bin;
      inherit (kwalletcli.meta) homepage license maintainers;
    };
  }
  ''
    mkdir -p $out/bin
    test -e ${bin'}
    ln -s ${bin'} $out/bin/${bin}
  ''
