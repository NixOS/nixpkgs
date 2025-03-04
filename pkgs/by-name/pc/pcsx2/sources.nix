{
  lib,
  fetchFromGitHub,
}:

let
  pcsx2 =
    let
      self = {
        pname = "pcsx2";
        version = "2.3.39";
        src = fetchFromGitHub {
          pname = "pcsx2-source";
          inherit (self) version;
          owner = "PCSX2";
          repo = "pcsx2";
          rev = "v${self.version}";
          hash = "sha256-Knlkf4GcN8OCgrd1nwdnYVCDA/7lyAfcoV4mLCkrHtg=";
        };
      };
    in
    self;

  # The pre-zipped files in releases don't have a versioned link, we need to zip
  # them ourselves
  pcsx2_patches =
    let
      self = {
        pname = "pcsx2_patches";
        version = "0-unstable-2024-11-23";
        src = fetchFromGitHub {
          pname = "pcsx2_patches-source";
          inherit (self) version;
          owner = "PCSX2";
          repo = "pcsx2_patches";
          rev = "5cc1d09a72c0afcd04e2ca089a6b279108328fda";
          hash = "sha256-or77ZsWU0YWtxj9LKJ/m8nDvKSyiF1sO140QaH6Jr64=";
        };
      };
    in
    self;
in
{
  inherit pcsx2 pcsx2_patches;
}
