{ stdenv, kwalletcli }:
stdenv.mkDerivation {
  pname = "pinentry-kwallet";
  version = kwalletcli.version;

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${kwalletcli}/bin/pinentry-kwallet $out/bin/pinentry-kwallet
  '';

  dontUnpack = true;
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontCheck = true;
  dontFixup = true;

  meta = {
    description = "Pinentry program for GnuPG that uses KWallet to store passphrases";
    longDescription = ''
      pinentry-kwallet is a pinentry program for GnuPG that uses KWallet to store passphrases.
      This allows automatically unlocking GnuPG keys on login. This package is a thin wrapper
      that symlinks to the pinentry-kwallet binary in the kwalletcli package to make it compatible
      with the `programs.gnupg.agent.pinentryPackage` option in NixOS.
    '';
    mainProgram = "pinentry-kwallet";
    inherit (kwalletcli.meta) homepage license maintainers;
  };
}
