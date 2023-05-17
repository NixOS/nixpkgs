{
  stable = import ./browser.nix {
    channel = "stable";
    version = "111.0.1661.44";
    revision = "1";
    sha256 = "sha256-ePViYQZUteMBkV7AkvsoQwPVxibMB68LDWgg7d82iIE=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "112.0.1722.15";
    revision = "1";
    sha256 = "sha256-Ba6f5MOBTtY8bUxCcMySQCWqDvOiI1hLnuwcIspReq8=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "113.0.1741.1";
    revision = "1";
    sha256 = "sha256-1d92bQAoiTkqWgiWdUBn3VKBYCRP1KCvPiu7cQTFVio=";
  };
}
