{
  stable = import ./browser.nix {
    channel = "stable";
<<<<<<< HEAD
    version = "115.0.1901.188";
    revision = "1";
    sha256 = "sha256-mRM3zakYwCptfKWYbiaDnPqv9Vt5WnDA7xIK1rlownU=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "115.0.1901.165";
    revision = "1";
    sha256 = "sha256-2DUWkGItissLGtJAMDKHNjMDPhsYNKaQVJ30+tMlkow=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "116.0.1938.10";
    revision = "1";
    sha256 = "sha256-NQXaLmX8AtLEWPkkzAA90XfmFflwulxVRHtIJ+nxCk4=";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
