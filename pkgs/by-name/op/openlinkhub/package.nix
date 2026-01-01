{
  buildGoModule,
  lib,
  fetchFromGitHub,
  udev,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "openlinkhub";
<<<<<<< HEAD
  version = "0.7.3";
=======
  version = "0.7.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "jurkovic-nikola";
    repo = "OpenLinkHub";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-Q9caDjiEQl2TAS6Myb3lHh9Th+/XPunMSTA06IMespM=";
=======
    hash = "sha256-lwrQZsoO62H81MUG70s1axonibMQYufCTj0/HPEA0wQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  proxyVendor = true;

  vendorHash = "sha256-xpIaQzl2jrWRIUe/1woODKLlwxQrdlCLkIk0qmWs7m0=";

  buildInputs = [
    udev
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/jurkovic-nikola/OpenLinkHub";
    platforms = lib.platforms.linux;
    description = "Open source interface for iCUE LINK Hub and other Corsair AIOs, Hubs for Linux";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.gpl3Only;
    mainProgram = "OpenLinkHub";
    changelog = "https://github.com/jurkovic-nikola/OpenLinkHub/releases/tag/${version}";
  };
}
