{
  stable = import ./browser.nix {
    channel = "stable";
    version = "117.0.2045.40";
    revision = "1";
    sha256 = "sha256-gRlw+hxix4CnviCrH+evmiwSctXJts8/68Oiwr5VKzk=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "118.0.2088.11";
    revision = "1";
    sha256 = "sha256-r++W+tnFxh85c9k4VooCy+6mre/8nU/7nrrt+AK1x+M=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "119.0.2109.1";
    revision = "1";
    sha256 = "sha256-ZIL8CD8eb/JvJs8P9GoT+yXWccS9roqPl6iDz+0K7LI=";
  };
}
