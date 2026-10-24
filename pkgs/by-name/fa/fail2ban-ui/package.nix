{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;
  pname = "fail2ban-ui";
  version = "1.4.9";

  src = fetchFromGitHub {
    owner = "swissmakers";
    repo = "fail2ban-ui";
    rev = "v.${finalAttrs.version}";
    sha256 = "sha256-zss+bsilPN7pLap3MmUK3xCIdakArVMQZt87ajtfUyM=";
  };

  vendorHash = "sha256-8HGWl2BgI39MkQIloBtatHxGDPcKj7uNBFu0vJGbYnY=";

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
