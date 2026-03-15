{
  lib,
  stdenv,
  makeWrapper,
  fetchurl,
  nodejs,
  coreutils,
  which,
}:
stdenv.mkDerivation rec {
  pname = "opensearch-dashboards";
  version = "3.5.0";

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://artifacts.opensearch.org/releases/bundle/${pname}/${version}/${pname}-${version}-linux-x64.tar.gz";
        hash = "sha256-g0aKKvi2rAd3AFdlfkotzoyREfoSTKJFI7bihjFu2wU=";
      };
      aarch64-linux = fetchurl {
        url = "https://artifacts.opensearch.org/releases/bundle/${pname}/${version}/${pname}-${version}-linux-arm64.tar.gz";
        hash = "sha256-HVgswQNHPZAN4PbDrvmHkiVwcnr2FrUBr5nwIwz+8BM=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/libexec/${pname} $out/bin
    mv * $out/libexec/${pname}/
    rm -r $out/libexec/${pname}/node
    makeWrapper $out/libexec/${pname}/bin/${pname} $out/bin/${pname} \
      --prefix PATH : "${
        lib.makeBinPath [
          nodejs
          coreutils
          which
        ]
      }"
    sed -i 's@NODE=.*@NODE=${nodejs}/bin/node@' $out/libexec/${pname}/bin/${pname}
  '';

  meta = {
    description = "Visualize logs and time-stamped data";
    homepage = "https://opensearch.org/docs/latest/dashboards/index/";
    maintainers = with lib.maintainers; [
      shymega
    ];
  };
}
