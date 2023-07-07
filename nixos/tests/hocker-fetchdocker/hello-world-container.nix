{ fetchDockerConfig, fetchDockerLayer, fetchdocker }:
fetchdocker rec {
    name = "hello-world";
    registry = "https://registry-1.docker.io/v2/";
    repository = "library";
    imageName = "hello-world";
    tag = "latest";
    imageConfig = fetchDockerConfig {
      inherit tag registry repository imageName;
      sha256 = "1ivbd23hyindkahzfw4kahgzi6ibzz2ablmgsz6340vc6qr1gagj";
    };
    imageLayers = let
      layer0 = fetchDockerLayer {
        inherit registry repository imageName;
        layerDigest = "ca4f61b1923c10e9eb81228bd46bee1dfba02b9c7dac1844527a734752688ede";
        sha256 = "1plfd194fwvsa921ib3xkhms1yqxxrmx92r2h7myj41wjaqn2kya";
      };
      in [ layer0 ];
  }
