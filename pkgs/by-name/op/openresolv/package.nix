{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openresolv";
  version = "3.17.4";

  src = fetchFromGitHub {
    owner = "NetworkConfiguration";
    repo = "openresolv";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-I86BHiSI3G4xlYRJC99elHw8RyUd3eHdkV5kiEGRXNE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  configurePhase = ''
    cat > config.mk <<EOF
    PREFIX=$out
    SYSCONFDIR=/etc
    SBINDIR=$out/sbin
    LIBEXECDIR=$out/libexec/resolvconf
    VARDIR=/run/resolvconf
    MANDIR=$out/share/man
    RESTARTCMD=false
    EOF
  '';

  installFlags = [ "SYSCONFDIR=$(out)/etc" ];

  postInstall = ''
    wrapProgram "$out/sbin/resolvconf" --set PATH "${coreutils}/bin"
  '';

  meta = {
    description = "Program to manage /etc/resolv.conf";
    mainProgram = "resolvconf";
    homepage = "https://roy.marples.name/projects/openresolv";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    teams = [ lib.teams.security-review ];
    platforms = lib.platforms.unix;
    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "openresolv_project" finalAttrs.version;
  };
})
