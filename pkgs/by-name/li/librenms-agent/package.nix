{
  stdenv,
  lib,
  fetchFromGitHub,
  testers,
  librenms-agent,
}:

stdenv.mkDerivation {
  pname = "librenms-agent";
  version = "1.2.6b5";

  src = fetchFromGitHub {
    owner = "librenms";
    repo = "librenms-agent";
    # upstream provides no git tags
    rev = "def5f830b3672526c4353a92a1804485f645733c";
    hash = "sha256-rzwSYJlor1LMGWDP4i/UYmuRccH0NflMC/fXDNd7QXA=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m 0750 check_mk_agent -t $out/bin/

    runHook postInstall
  '';

  passthru.tests = {
    version = testers.testVersion { package = librenms-agent; };
  };

  meta = {
    description = "Agent that provides data to LibreNMS";
    homepage = "https://github.com/librenms/librenms-agent";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.Nebucatnetzer ];
    platforms = lib.platforms.linux;
    mainProgram = "check_mk_agent";
  };
}
