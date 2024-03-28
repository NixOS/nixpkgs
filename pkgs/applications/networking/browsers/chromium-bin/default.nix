{
  lib,
  extractDarwinApp,
  fetchzip,
  stdenv,
}:
let
  specs = {
    aarch64-darwin = {
      arch = "Mac_Arm";
      sha256 = "sha256-8FeYbXzMDoTVxeAaKe3F4SYRKDz2pirRj3BAF7gtCR8=";
      version = "1169958";
    };
    x86_64-darwin = {
      arch = "Mac";
      sha256 = "sha256-Dje78MSnczxHIzJG7xXkTUqF/nsdSOAvpKhGU/rxoTg=";
      version = "1171203";
    };
  };
  spec = specs.${stdenv.hostPlatform.system} or ({
      arch = "";
      sha25 = "";
      version = "";
  });
in
extractDarwinApp rec {
  appName = "Chromium";
  binaryName = appName;
  pname = "chromium-bin";
  version = spec.version;
  src = fetchzip {
    url = "https://commondatastorage.googleapis.com/chromium-browser-snapshots/${spec.arch}/${spec.version}/chrome-mac.zip";
    sha256 = spec.sha256;
  };

  wrapBinary = true;
  packageMeta = {
      description = "An open source web browser from Google";
      platforms = builtins.attrNames specs;
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [
        michaelCTS
      ];
  };
}
