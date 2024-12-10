let
  self = {
    "16.09" =
      "https://nixos.blob.core.windows.net/images/nixos-image-16.09.1694.019dcc3-x86_64-linux.vhd";

    latest = self."16.09";
  };
in
self
