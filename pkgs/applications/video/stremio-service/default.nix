{ lib, stdenv, fetchurl, fetchFromGitHub, rustPlatform, pkg-config, openssl, gtk3 }:

rustPlatform.buildRustPackage rec {
  pname = "stremio-service";
  version = "0.1.8";

  src = stdenv.mkDerivation rec {
    name = "${pname}-source-${version}";
    src = fetchFromGitHub {
      owner = "Stremio";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-PySvGT7Za5NeQgW1OwAo3ja9FnKrQ/ofh217RkWewW0=";
    };
    server-js = fetchurl {
      url = "https://dl.strem.io/server/v4.20.2/desktop/server.js";
      sha256 = "sha256-YtoQG8ppBVpe86DjyRKhDwmHhVRYpIOkEDuH21YseWA=";
    };
    installPhase = ''
      mkdir -p $out
      cp -R ./* $out/
      ls -al $out/resources/bin/linux/
      cp ${server-js} $out/resources/bin/linux/server.js
      ls -al $out/resources/bin/linux/
    '';
  };

  buildFeatures = [ "offline-build" "bundled" ];
  doCheck = false;
  cargoCheckFeatures = [ "offline-build" "bundled" ];
  cargoSha256 = "sha256-aHIkHw2KvveuURq5yvSLXACIinQF89ZtHuV5o2fJmks=";
  buildInputs = [ gtk3 openssl ];
  nativeBuildInputs = [ pkg-config ];
  meta = with lib; {
    description = "A companion app for Stremio Web";
    homepage = "https://github.com/Stremio/stremio-service";
    license = licenses.gpl2;
    maintainers = [ ];
  };
}
