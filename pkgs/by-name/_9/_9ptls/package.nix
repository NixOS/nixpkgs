{
  lib,
  stdenv,
  tlsclient,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit (tlsclient) src version enableParallelBuilding;
  pname = "9ptls";

  strictDeps = true;

  buildFlags = [ "mount.9ptls" ];
  installFlags = [
    "PREFIX=$(out)"
    "SBIN=$(out)/bin"
  ];
  installTargets = "mount.9ptls.install";

  meta = {
    description = "mount.9ptls mount helper";
    longDescription = ''
      mount.9ptls wraps the v9fs mount type in a dp9ik authenticated
      tls tunnel using tlsclient.
    '';
    homepage = "https://git.sr.ht/~moody/tlsclient";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moody ];
    mainProgram = "mount.9ptls";
    platforms = lib.platforms.linux;
  };
})
