{ qt6Packages, makeScopeWithSplicing', generateSplicesForMkScope, vulkan-headers, fetchFromGitHub }:

makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "yuzuPackages";
  f = self: qt6Packages // {
    compat-list = self.callPackage ./compat-list.nix {};
    nx_tzdb = self.callPackage ./nx_tzdb.nix {};

    mainline = self.callPackage ./mainline.nix {};
    early-access = self.callPackage ./early-access {};

    vulkan-headers = vulkan-headers.overrideAttrs(old: rec {
      version = "1.3.274";
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "Vulkan-Headers";
        rev = "v${version}";
        hash = "sha256-SsS5VlEnhjOSu8MlIVC0d2r2EAf8QsNJPEAXNtbDOJ4=";
      };
    });
  };
}
