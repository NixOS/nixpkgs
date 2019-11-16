{ stdenv, lib, fetchFromGitHub, buildGoPackage, makeWrapper }:

let

  # Cache schema as a package so network calls are not
  # necessary at runtime, allowing use in package builds
  schema = stdenv.mkDerivation {
    name = "kubeval-schema";
    src = fetchFromGitHub {
      owner = "garethr";
      repo = "kubernetes-json-schema";
      rev = "c7672fd48e1421f0060dd54b6620baa2ab7224ba";
      sha256 = "0picr3wvjx4qv158jy4f60pl225rm4mh0l97pf8nqi9h9x4x888p";
    };

    installPhase = ''
      mkdir -p $out/kubernetes-json-schema/master
      cp -R . $out/kubernetes-json-schema/master
    '';
   };

in

buildGoPackage rec {
  pname = "kubeval";
  version = "0.7.3";

  goPackagePath = "github.com/garethr/kubeval";
  src = fetchFromGitHub {
    owner = "garethr";
    repo = "kubeval";
    rev = version;
    sha256 = "042v4mc5p80vmk56wp6aw89yiibjnfqn79c0zcd6y179br4gpfnb";
  };
  goDeps = ./deps.nix;

  buildInputs = [ makeWrapper ];

  postFixup = "wrapProgram $bin/bin/kubeval --set KUBEVAL_SCHEMA_LOCATION file:///${schema}";

  meta = with lib; {
    description = "Validate your Kubernetes configuration files";
    homepage = https://github.com/garethr/kubeval;
    license = licenses.asl20;
    maintainers = with maintainers; [ nicknovitski ];
    platforms = platforms.all;
  };
}
