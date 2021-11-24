{ lib, stdenv, fetchurl  }:

stdenv.mkDerivation rec {
  pname = "marp";
  version = "1.4.2";

  src = fetchurl {
    url = "https://github.com/marp-team/marp-cli/releases/download/v${version}/marp-cli-v${version}-linux.tar.gz";
    sha256 = "sha256-URdpmuveb9xEyeHLABeyObZjT6XaXv9tPgrxH9XdBZk=";
  };

  unpackPhase = ''
    tar -xf $src
  '';

  installPhase = ''
    mkdir -p $out/bin/
    cp -r ./marp $out/bin/
  '';

  postFixup = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}" \
      $out/bin/marp
  '';

  meta = with lib; {
    description = "CLI interface for Marp and Marpit based converters";
    homepage = "https://marp.app/";
    license = licenses.mit;
    maintainers = with maintainers; [ puffnfresh kvark ];
    platforms = [ "x86_64-linux" ];
  };
}
