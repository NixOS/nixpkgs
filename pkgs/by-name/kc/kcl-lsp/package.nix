{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "kcl-lsp";
  version = "0.8.3";

  src = if stdenv.isDarwin && stdenv.isx86_64 then fetchurl {
    url = "https://github.com/kcl-lang/kcl/releases/download/v${version}/kclvm-v${version}-darwin-amd64.tar.gz";
    sha256 = "f1825109c6ab9f54c7559fc1dc706a773aa5f675bc16ef0b0fc68fa8be0378d0";
  } else if stdenv.isDarwin && stdenv.isAarch64 then fetchurl {
    url = "https://github.com/kcl-lang/kcl/releases/download/v${version}/kclvm-v${version}-darwin-arm64.tar.gz";
    sha256 = "6204aa3659f87b618e08c60bab6c05c238aab20daa4f2fcc6b4c9b7160725a6e";
  } else if stdenv.isLinux && stdenv.isx86_64 then fetchurl {
    url = "https://github.com/kcl-lang/kcl/releases/download/v${version}/kclvm-v${version}-linux-amd64.tar.gz";
    sha256 = "52f49026a7767388ffa6147138d770314e1554ec437619abcde6f3bd0a1a1563";
  } else if stdenv.isLinux && stdenv.isAarch64 then fetchurl {
    url = "https://github.com/kcl-lang/kcl/releases/download/v${version}/kclvm-v${version}-linux-arm64.tar.gz";
    sha256 = "49698899fdce62f6806d8c11402cd10ea86e35762baae7283e5f5338dbb0bd58";
  } else throw "Unsupported platform";

  unpackPhase = "tar -xzf $src";

  installPhase = ''
    mkdir -p $out/libexec
    cp -R * $out/libexec
    mkdir -p $out/bin
    cp $out/libexec/bin/kcl-language-server $out/bin/
  '';

  meta = with lib; {
    description = "A constraint-based record & functional language mainly used in configuration and policy scenarios.";
    homepage = "https://kcl-lang.io";
    license = licenses.asl20; # Apache License 2.0
    maintainers = with maintainers; [ kcl-lang ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
