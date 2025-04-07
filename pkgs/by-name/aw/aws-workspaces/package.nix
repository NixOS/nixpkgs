{
  stdenv,
  lib,
  callPackage,
  writeShellApplication,
  buildFHSEnv,
  webkitgtk_4_1,
  gtk3,
  pango,
  atk,
  cairo,
  gdk-pixbuf,
  protobufc,
  cyrus_sasl,
}:

let
  workspacesclient = callPackage ./workspacesclient.nix { };

  # Source: https://github.com/jthomaschewski/pkgbuilds/pull/3
  # Credits to https://github.com/rwolfson
  custom_lsb_release = writeShellApplication {
    name = "lsb_release";

    text = ''
      # "Fake" lsb_release script
      # This only exists so that "lsb_release -r" will return the below string
      # when placed in the $PATH

      if [ "$#" -ne 1 ] || [ "$1" != "-r" ] ; then
          echo "Expected only '-r' argument"
          exit 1
      fi

      echo "Release: 22.04"
    '';
  };
  pname = "aws-workspaces";

in
buildFHSEnv {
  inherit pname;
  inherit (workspacesclient) version;

  runScript = "${workspacesclient}/bin/workspacesclient";

  includeClosures = true;

  targetPkgs =
    pkgs: with pkgs; [
      workspacesclient
      custom_lsb_release
      webkitgtk_4_1
      gtk3
      pango
      atk
      cairo
      gdk-pixbuf
      protobufc
      cyrus_sasl
    ];

  extraBwrapArgs = [
    # provide certificates where Debian-style OpenSSL can find them
    "--symlink /etc/ssl/certs/ca-certificates.crt /etc/ssl/cert.pem"
  ];

  # expected executable doesn't match the name of this package
  extraInstallCommands = ''
    mv $out/bin/${pname} $out/bin/workspacesclient
  '';

  meta = workspacesclient.meta;
}
