{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "kcl";
  version = "0.8.4";

  src = if stdenv.isDarwin && stdenv.isAarch64 then fetchurl {
    url = "https://github.com/kcl-lang/cli/releases/download/v${version}/kcl-v${version}-darwin-arm64.tar.gz";
    sha256 = "830c5cd7e0dd500c777a26d87924472589d389b8d61c936e6d67df85046fe2de";
  } else if stdenv.isDarwin && stdenv.isx86_64 then fetchurl {
    url = "https://github.com/kcl-lang/cli/releases/download/v${version}/kcl-v${version}-darwin-amd64.tar.gz";
    sha256 = "4cca464d25df170f1679e1b5bd72cba886a9e5659f3af624953a132d11625378";
  } else if stdenv.isLinux && stdenv.isAarch64 then fetchurl {
    url = "https://github.com/kcl-lang/cli/releases/download/v${version}/kcl-v${version}-linux-arm64.tar.gz";
    sha256 = "0f489d2a85c041a36c804cc1026bb5d705059067bdfc895bc288a2293cf87ca0";
  } else if stdenv.isLinux && stdenv.isx86_64 then fetchurl {
    url = "https://github.com/kcl-lang/cli/releases/download/v${version}/kcl-v${version}-linux-amd64.tar.gz";
    sha256 = "9a86ef943ca7df1a21801fb91be8092d04835d1d555c146da89c1149d33a4c42";
  } else throw "Unsupported platform";

  unpackPhase = "tar -xzf $src";

  installPhase = ''
    mkdir -p $out/bin
    cp kcl $out/bin/
  '';

  meta = with lib; {
    description = "KCL Command Line Interface";
    homepage = "https://github.com/kcl-lang/kcl";
    license = licenses.asl20;
    maintainers = with maintainers; [ kcl-lang ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
