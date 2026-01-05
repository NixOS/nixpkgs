{
  lib,
  tlsclient,
  stdenv,
  pkg-config,
  pam,
}:

stdenv.mkDerivation {
  inherit (tlsclient) src version enableParallelBuilding;

  pname = "pam_dp9ik";

  strictDeps = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pam ];

  buildFlags = [ "pam_p9.so" ];
  installFlags = [ "PREFIX=$(out)" ];
  installTargets = "pam.install";

  meta = {
    description = "dp9ik pam module";
    longDescription = "Uses tlsclient to authenticate users against a 9front auth server";
    homepage = "https://git.sr.ht/~moody/tlsclient";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.platforms.linux;
  };
}
