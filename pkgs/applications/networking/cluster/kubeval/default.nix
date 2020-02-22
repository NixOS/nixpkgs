{ stdenv, lib, fetchFromGitHub, buildGoModule, makeWrapper }:

let

  # Cache schema as a package so network calls are not
  # necessary at runtime, allowing use in package builds
  schema = stdenv.mkDerivation {
    name = "kubeval-schema";
    src = fetchFromGitHub {
      owner = "instrumenta";
      repo = "kubernetes-json-schema";
      rev = "6a498a60dc68c5f6a1cc248f94b5cd1e7241d699";
      sha256 = "1y9m2ma3n4h7sf2lg788vjw6pkfyi0fa7gzc870faqv326n6x2jr";
    };

    installPhase = ''
      mkdir -p $out/kubernetes-json-schema/master
      cp -R . $out/kubernetes-json-schema/master
    '';
   };

in

buildGoModule rec {
  pname = "kubeval";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "instrumenta";
    repo = "kubeval";
    rev = "${version}";
    sha256 = "0kpwk7bv36m3i8vavm1pqc8l611c6l9qbagcc64v6r85qig4w5xv";
  };

  buildInputs = [ makeWrapper ];

  modSha256 = "0y9x44y3bchi8xg0a6jmp2rmi8dybkl6qlywb6nj1viab1s8dd4y";

  postFixup = "wrapProgram $out/bin/kubeval --set KUBEVAL_SCHEMA_LOCATION file:///${schema}/kubernetes-json-schema/master";

  meta = with lib; {
    description = "Validate your Kubernetes configuration files";
    homepage = https://github.com/instrumenta/kubeval;
    license = licenses.asl20;
    maintainers = with maintainers; [ nicknovitski ];
    platforms = platforms.all;
  };
}
