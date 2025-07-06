{ lib
, stdenv
, fetchurl
, gnutar
}:

let
  platformInfo = {
    "x86_64-linux" = {
      arch = "linux_amd64";
      sha256 = "sha256-gBdeN06fDcFP37+Igw7YGMR9Qy9kP8wMd/lqgrEEHEo=";
    };
    "aarch64-linux" = {
      arch = "linux_arm64";
      sha256 = "sha256-1vh3vnlnr609qwm36hwy0qgh6dyvsa2wb8mc6nm5b0kxw513ldp2";
    };
    "x86_64-darwin" = {
      arch = "darwin_amd64";
      sha256 = "sha256-0l3rp3p7brwgpwh723lvx4fcq1ykk08b9yxc3iaq7j91lhm04a02";
    };
    "aarch64-darwin" = {
      arch = "darwin_arm64";
      sha256 = "sha256-0nmi26j422wr61ddd15mfvhvsg4ap5560a9zsfp9zmaj0i4cyvpa";
    };
  };

  platform = platformInfo.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

in
stdenv.mkDerivation rec {
  pname = "semaphoreui";
  version = "2.15.0";

  src = fetchurl {
    url = "https://github.com/semaphoreui/semaphore/releases/download/v${version}/semaphore_${version}_${platform.arch}.tar.gz";
    sha256 = platform.sha256;
  };

  nativeBuildInputs = [ gnutar ];

  unpackPhase = ''
    tar xf $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp semaphore $out/bin/
    chmod +x $out/bin/semaphore
  '';

  meta = with lib; {
    description = "Modern UI and powerful API for Ansible, Terraform, OpenTofu, PowerShell and other DevOps tools";
    homepage = "https://semaphoreui.com/";
    changelog = "https://github.com/semaphoreui/semaphore/releases/tag/v${version}";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ tellmeY18 ];
    mainProgram = "semaphore";
  };
}
