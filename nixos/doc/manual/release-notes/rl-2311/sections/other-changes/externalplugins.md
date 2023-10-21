- CoreDNS can now be built with external plugins by overriding `externalPlugins` and `vendorHash` arguments like this:

  ```
  services.coredns = {
    enable = true;
    package = pkgs.coredns.override {
      externalPlugins = [
        {name = "fanout"; repo = "github.com/networkservicemesh/fanout"; version = "v1.9.1";}
      ];
      vendorHash = "<SRI hash>";
    };
  };
  ```

  To get the necessary SRI hash, set `vendorHash = "";`. The build will fail and produce the correct `vendorHash` in the error message.

  If you use this feature, updates to CoreDNS may require updating `vendorHash` by following these steps again.
