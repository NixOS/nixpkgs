{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "k3s";
  version = "1.0.0";

  src = let
    throwError = throw "Unsupported system ${stdenv.hostPlatform.system}";
  in {
    x86_64-linux = fetchurl {
      url = "https://github.com/rancher/k3s/releases/download/v${version}/k3s";
      sha256 = "1abj0vmnsgfa753r1yv7pkxp0s0ms703ma8sfr6cbqnhp256byik";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/rancher/k3s/releases/download/v${version}/k3s-arm64";
      sha256 = "01q6dmf3gi6dvh812wmdqay2wrn831s04dm9ax63k47jjy6nbig3";
    };
    armv7l-linux = fetchurl {
      url = "https://github.com/rancher/k3s/releases/download/v${version}/k3s-armhf";
      sha256 = "1p8ji85igkhhhvhkx2c1i5ji6rysn6ym9nzmhs64rcy410b1mk1h";
    };
  }.${stdenv.hostPlatform.system} or throwError;

  preferLocalBuild = true;
  dontUnpack = true;
  installPhase = "install -Dm755 $src $out/bin/k3s";

  meta = with stdenv.lib; {
    description = "Lightweight Kubernetes. 5 less than k8s.";
    homepage = https://k3s.io/;
    license = licenses.asl20;
    maintainers = [ maintainers.offline ];
    platforms = [ "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
  };
}
