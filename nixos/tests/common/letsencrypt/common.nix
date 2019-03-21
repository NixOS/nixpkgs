{ lib, nodes, ... }: {
  networking.nameservers = [
    nodes.letsencrypt.config.networking.primaryIPAddress
  ];

  nixpkgs.overlays = lib.singleton (self: super: {
    cacert = super.cacert.overrideDerivation (drv: {
      installPhase = (drv.installPhase or "") + ''
        cat "${nodes.letsencrypt.config.test-support.letsencrypt.caCert}" \
          >> "$out/etc/ssl/certs/ca-bundle.crt"
      '';
    });

    # Override certifi so that it accepts fake certificate for Let's Encrypt
    # Need to override the attribute used by simp_le, which is python3Packages
    python3Packages = (super.python3.override {
      packageOverrides = lib.const (pysuper: {
        certifi = pysuper.certifi.overridePythonAttrs (attrs: {
          postPatch = (attrs.postPatch or "") + ''
            cat "${self.cacert}/etc/ssl/certs/ca-bundle.crt" \
              > certifi/cacert.pem
          '';
        });
      });
    }).pkgs;
  });
}
