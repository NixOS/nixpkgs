{ lib, stdenv, fetchurl, rpmextract, patchelf, testers, scaleft }:

stdenv.mkDerivation rec {
  pname = "scaleft";
  version = "1.80.1";

  src =
    fetchurl {
      url = "https://dist.scaleft.com/repos/rpm/stable/centos/9/x86_64/1.80.1/scaleft-client-tools-${version}-1.x86_64.rpm";
      sha256 = "sha256-QrkqAgkplFF6Tp6FWKb2TJaqeOw8ec4zd9pymDP2IyY=";
    };

  nativeBuildInputs = [ patchelf rpmextract ];

  libPath =
    lib.makeLibraryPath
       [ stdenv.cc stdenv.cc.cc.lib ];

  buildCommand = ''
    mkdir -p $out/bin/
    cd $out
    rpmextract $src
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      usr/bin/sft
    patchelf \
      --set-rpath ${libPath} \
      usr/bin/sft
    ln -s $out/usr/bin/sft $out/bin/sft
    chmod +x $out/bin/sft
    patchShebangs $out
  '';

  passthru.tests.version = testers.testVersion {
    package = scaleft;
    command = "sft -v";
    version = "sft version ${version}";
  };

  meta = with lib; {
    description = "ScaleFT provides Zero Trust software which you can use to secure your internal servers and services";
    homepage = "https://www.scaleft.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ jloyet ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "sft";
  };
}
