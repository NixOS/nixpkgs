{
  stdenv,
  lib,
  fetchFromGitHub,
  jq,
  nix,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "terranix";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "mrVanDalo";
    repo = "terranix";
    rev = version;
    sha256 = "sha256-xiUfVD6rtsVWFotVtUW3Q1nQh4obKzgvpN1wqZuGXvM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,core,modules,lib}
    mv bin core modules lib share $out/

    wrapProgram $out/bin/terranix-doc-json \
      --prefix PATH : ${
        lib.makeBinPath [
          jq
          nix
        ]
      }
  '';

  meta = with lib; {
    description = "NixOS like terraform-json generator";
    homepage = "https://terranix.org";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mrVanDalo ];
  };
}
