{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
}:

stdenv.mkDerivation rec {
  pname = "openresolv";
  version = "3.14.1";

  src = fetchFromGitHub {
    owner = "NetworkConfiguration";
    repo = "openresolv";
    rev = "v${version}";
    sha256 = "sha256-cz3hNfv5t/crxTrJLP0lUtyP2oFR2tZINfIV62p4Rzo=";
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
    platforms = lib.platforms.unix;
  };
}
