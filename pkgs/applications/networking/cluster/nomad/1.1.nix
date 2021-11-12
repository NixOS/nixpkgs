{ callPackage
, buildGoModule
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./genericModule.nix {
  inherit buildGoModule nvidia_x11 nvidiaGpuSupport;
  version = "1.1.6";
  sha256 = "1q6fqay1s9qwimjwlldc8hr6009cgx3ghz142mdx36jjv9isj9ln";
  vendorSha256 = "0rfd22rf76mwj489zhswah4g3dhhz6davm336xgm9dbnyaz9d8r0";
}
