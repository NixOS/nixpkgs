{ lib
, stdenv
, makeWrapper
, fetchurl
, nodejs
, coreutils
, which
}:

stdenv.mkDerivation rec {
  pname = "opensearch-dashboards";
  version = "2.11.0";

  src = fetchurl {
    url = "https://artifacts.opensearch.org/releases/bundle/${pname}/${version}/${pname}-${version}-linux-x64.tar.gz";
    sha512 = "sha512-HREIKoWmLDAag1tBU0ZyuPlni8LgxB0Xjpdnra/McP7NIAVR3xo4HulSYn+FcUDK6Sp1nVoJNO9fxxF4M1a71A==";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/libexec/${pname} $out/bin
    mv * $out/libexec/${pname}/
    rm -r $out/libexec/${pname}/node
    makeWrapper $out/libexec/${pname}/bin/${pname} $out/bin/${pname} \
      --prefix PATH : "${lib.makeBinPath [ nodejs coreutils which ]}"
    sed -i 's@NODE=.*@NODE=${nodejs}/bin/node@' $out/libexec/${pname}/bin/${pname}
  '';

  meta = with lib; {
    description = "Visualize logs and time-stamped data";
    homepage = "https://opensearch.org/docs/latest/dashboards/index/";
    maintainers = with lib.maintainers; [ _0z13 ];
  };
}

