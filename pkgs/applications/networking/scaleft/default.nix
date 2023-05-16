<<<<<<< HEAD
{ lib, stdenv, fetchurl, rpmextract, patchelf, bash, testers, scaleft }:

stdenv.mkDerivation rec {
  pname = "scaleft";
  version = "1.67.4";
=======
{ lib, stdenv, fetchurl, rpmextract, patchelf, bash }:

stdenv.mkDerivation rec {
  pname = "scaleft";
  version = "1.45.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src =
    fetchurl {
      url = "http://pkg.scaleft.com/rpm/scaleft-client-tools-${version}-1.x86_64.rpm";
<<<<<<< HEAD
      sha256 = "kRCShTMKf5qKFth/8H8XHLj12YIVQ9G5f2MvVJRtyDs=";
=======
      sha256 = "1yskybjba9ljy1wazddgrm7a4cc72i1xbk7sxnjpcq4hdy3b50l0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  passthru.tests.version = testers.testVersion {
    package = scaleft;
    command = "sft -v";
    version = "sft version ${version}";
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "ScaleFT provides Zero Trust software which you can use to secure your internal servers and services";
    homepage = "https://www.scaleft.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ jloyet ];
    platforms = [ "x86_64-linux" ];
  };
}
