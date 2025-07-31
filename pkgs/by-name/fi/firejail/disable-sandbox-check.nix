import ./generic.nix {
  pname = "firejail-disable-sandbox-check";
  extraConfigureFlags = [ "--disable-sandbox-check" ];
  extraLongDescription = ''
    Builded with --disable-sandbox-check, which is only intended for
    development.
  '';
}
