{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:
buildGoModule (finalAttrs: {
  pname = "gtpdoor-scan";
  version = "0.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "haxrob";
    repo = "gtpdoor-scan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jVF37FzrdkPe7C7pvj73vxHWDJcxiH5UekaM42RNOEg=";
  };

  vendorHash = "sha256-SSVz4WMi0MCeXkinhiLzyWn3UEmDk+3WwyVkFwAHbzI=";

  buildInputs = [ libpcap ];

  meta = {
    description = "Network scanner to scan for hosts infected with the GTPDOOR malware";
    homepage = "https://github.com/haxrob/gtpdoor-scan";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
