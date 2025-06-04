{
  stdenv,
  callPackage,
  fetchurl,
  lib,
}:

let

  pname = "freelens";
  version = "1.3.0";

  sources = {
    x86_64-linux = {
      url = "https://github.com/freelensapp/freelens/releases/download/v1.3.0/Freelens-${version}-linux-amd64.AppImage";
      hash = "sha256-xLxd2q8SegYGcjMwzKpAK7N99VyrkZLnoK919O1RlDk=";
    };
    aarch64-linux = {
      url = "https://github.com/freelensapp/freelens/releases/download/v1.3.0/Freelens-${version}-linux-arm64.AppImage";
      hash = "sha256-wEuH4uQfxs6rdVAkAIV69jXXrAkdF5EX3NiMN+a+lh8=";
    };
    x86_64-darwin = {
      url = "https://github.com/freelensapp/freelens/releases/download/v1.3.0/Freelens-${version}-macos-amd64.dmg";
      hash = "sha256-XFtvlrAYKwWt8n9kMMVZKHEHkho1eN7SvNA6lkeaX+M=";
    };
    aarch64-darwin = {
      url = "https://github.com/freelensapp/freelens/releases/download/v1.3.0/Freelens-${version}-macos-arm64.dmg";
      hash = "sha256-GHzOo8iT/RWZst3Hrqk90s7s+wP8Q6j7hDB4EcZar1k=";
    };
  };

  src = fetchurl {
    inherit (sources.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}")) url hash;
  };

  meta = with lib; {
    description = "Free IDE for Kubernetes";
    longDescription = ''
      Freelens is a free and open-source user interface designed for managing Kubernetes clusters. It provides a standalone application compatible with macOS, Windows, and Linux operating systems, making it accessible to a wide range of users. The application aims to simplify the complexities of Kubernetes management by offering an intuitive and user-friendly interface.
    '';
    homepage = "https://github.com/freelensapp/freelens/";
    license = licenses.mit;
    maintainers = with maintainers; [ skwig ];
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
