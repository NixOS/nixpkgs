{ fetchFromGitLab }:

{
  feedbackd-device-themes =
    let
      self = {
        pname = "feedbackd-device-themes";
        version = "0.4.0";

        src = fetchFromGitLab {
          pname = "feedbackd-device-themes-source";
          inherit (self) version;
          domain = "source.puri.sm";
          owner = "Librem5";
          repo = "feedbackd-device-themes";
          rev = "v${self.version}";
          hash = "sha256-kY/+DyRxKEUzq7ctl6Va14AKUCpWU7NRQhJOwhtkJp8=";
        };
      };
    in
    self;

  feedbackd =
    let
      self = {
        pname = "feedbackd";
        version = "0.4.1";

        src = fetchFromGitLab {
          pname = "feedbackd-source";
          inherit (self) version;
          domain = "source.puri.sm";
          owner = "Librem5";
          repo = "feedbackd";
          rev = "v${self.version}";
          hash = "sha256-ta14DYqkid8Cp8fx9ZMGOOJroCBszN9/VrTN6mrpTZg=";
        };
      };
    in
    self;
}
