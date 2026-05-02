{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "fail2ban-ui";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "swissmakers";
    repo = "fail2ban-ui";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-jzU1T60vc6YJyyCnx1v1ab4GIpdPEJQrjKu8y4YiBg4=";
  };

  vendorHash = "sha256-RBlwNcEwUwM49ERXSDd4g/3/qKFSCAIrAp8w4adlf/g=";

  # They name their main binary "server" O.o
  postInstall = ''
    mv $out/bin/server $out/bin/${finalAttrs.meta.mainProgram}
  '';

  meta = {
    description = "swissmade web interface for operating Fail2Ban across one or more Linux hosts";
    longDescription = ''
      Fail2Ban UI is a swissmade web interface for operating Fail2Ban across
      one or more Linux hosts. It provides a central place to review bans,
      search and unban IPs, manage jails and filters, and receive
      notifications.
    '';
    homepage = "https://github.com/swissmakers/fail2ban-ui";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "fail2ban-ui";
  };
})
