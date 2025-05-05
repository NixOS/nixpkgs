{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "uroboros";
  version = "20210304-${lib.strings.substring 0 7 rev}";
  rev = "9bed95bb4cc44cfd043e8ac192e788df379c7a44";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = pname;
    inherit rev;
    hash = "sha256-JB4KMjD0ldJkKWKkArA/vfIdeX/TwxWPPOteob5gK6g=";
  };

  vendorHash = "sha256-FJTmnkPMXolNijRc4ZqCsi/ykReTE2WOC5LP/wHog9Y=";

  meta = with lib; {
    description = "Tool for monitoring and profiling single processes";
    homepage = "https://github.com/evilsocket/uroboros";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
