{ autoPatchelfHook
, callPackage
, dpkg
, fetchurl
, lib
, stdenv
# Package dependencies
, curl
, fuse
, libsearpc
, sqlite
}:

let
  # Grab libevent-2.0 from old nixpkgs
  # seadrive specifically looks for libevent-2.0 and fails with libevent-2.1
  libevent-2_0-src = fetchurl {
    url = "https://github.com/NixOS/nixpkgs/raw/3be19de8e4eba036d1c6ae81295beee1871a7fef~1/pkgs/development/libraries/libevent/default.nix";
    sha256 = "07x7i3bsm8xngap2baivbza0fnj3jalmfq57avymzfyqy17sb2j4";
  };
  libevent-2_0 = callPackage libevent-2_0-src {};
in stdenv.mkDerivation rec {
  version = "1.0.0";
  pname = "seadrive-daemon";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://deb.seadrive.org/jessie/pool/main/s/${pname}/${pname}_${version}_amd64.deb";
    sha256 = "09nbgcgqzxdb4f1c6dw8azvhpcap88frc64da0d49f7lrikgd49l";
  };

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    curl
    fuse
    libevent-2_0
    libsearpc
    sqlite
  ];

  installPhase = ''
    mkdir --parent $out
    mv * $out/
  '';

  meta = {
    homepage = "https://www.seafile.com/en/home/";
    description = "The SeaDrive client enables you to access files on the Seafile server without syncing to local disk. It works like a network drive.";
    platforms = [ "x86_64-linux" ];
    license = stdenv.lib.licenses.unfree;
  };
}
