{
  stdenv,
  callPackage,
  fetchurl,
  lib,
}:

let

  pname = "freelens";
  version = "1.5.2";

  sources = {
    x86_64-linux = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-linux-amd64.AppImage";
      hash = "sha256-vngH7di2tkouJS+2QUyLCGhigNb4CMi4aPoTGJiXzcA=";
    };
    aarch64-linux = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-linux-arm64.AppImage";
      hash = "sha256-ypNp1kbe7HkuPq4hnn9rJMqoImk+mlWhS8dphc053vc=";
    };
    x86_64-darwin = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-macos-amd64.dmg";
      hash = "sha256-DkZxFtEHRp0vfdb4iXkWwjf3Pd4PahEPSae4cIfpfbI=";
    };
    aarch64-darwin = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-macos-arm64.dmg";
      hash = "sha256-hOc6K9KlBNRIcQvK0r9kkrsDv2fMhy5py0EjFIQY1h4=";
    };
  };

  src = fetchurl {
    inherit (sources.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}")) url hash;
  };

  meta = {
    description = "Free IDE for Kubernetes";
    longDescription = ''
      Freelens is a free and open-source user interface designed for managing Kubernetes clusters. It provides a standalone application compatible with macOS, Windows, and Linux operating systems, making it accessible to a wide range of users. The application aims to simplify the complexities of Kubernetes management by offering an intuitive and user-friendly interface.
    '';
    homepage = "https://github.com/freelensapp/freelens/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ skwig ];
    platforms = builtins.attrNames sources;
  };

in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit
      pname
      version
      src
      meta
      ;
  }
else
  callPackage ./linux.nix {
    inherit
      pname
      version
      src
      meta
      ;
  }
