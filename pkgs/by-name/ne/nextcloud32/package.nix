{
  nextcloud33,
  nextcloud32Packages,
  fetchurl,
}:

(nextcloud33.override {
  nextcloudPackages = nextcloud32Packages;
}).overrideAttrs
  (
    finalAttrs: oldAttrs: {
      version = "32.0.6";

      src = fetchurl {
        url = "https://download.nextcloud.com/server/releases/nextcloud-${finalAttrs.version}.tar.bz2";
        hash = "sha256-RLwz/A4xplC7UguxI8CqplGbf3uThhM9Vhred+U/cTA=";
      };
    }
  )
