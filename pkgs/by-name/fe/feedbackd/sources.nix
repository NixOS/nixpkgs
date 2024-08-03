{ fetchFromGitLab }:

{
  feedbackd-device-themes =
    let
      self = {
        pname = "feedbackd-device-themes";
        version = "0.1.0";

        src = fetchFromGitLab {
          domain = "source.puri.sm";
          owner = "Librem5";
          repo = "feedbackd-device-themes";
          rev = "v${self.version}";
          hash = "sha256-YK9fJ3awmhf1FAhdz95T/POivSO93jsNApm+u4OOZ80=";
        };
      };
    in
    self;

  feedbackd =
    let
      self = {
        pname = "feedbackd";
        version = "0.2.0";

        src = fetchFromGitLab {
          domain = "source.puri.sm";
          owner = "Librem5";
          repo = "feedbackd";
          rev = "v${self.version}";
          fetchSubmodules = true;
          hash = "sha256-l5rfMx3ElW25A5WVqzfKBp57ebaNC9msqV7mvnwv10s=";
        };
      };
    in
    self;
}
