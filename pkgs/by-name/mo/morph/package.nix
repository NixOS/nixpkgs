{
  buildGoModule,
  fetchFromGitHub,
  lib,
  makeWrapper,
  openssh,
}:

buildGoModule rec {
  pname = "morph";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "dbcdk";
    repo = "morph";
    rev = "v${version}";
    hash = "sha256-IqWtVklzSq334cGgLx/13l329g391oDW50MZWyO6l08=";
  };

  vendorHash = "sha256-zQlMtbXgrH83zrcIoOuFhb2tYCeQ1pz4UQUvRIsLMCE=";

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-X main.version=${version}"
    "-X main.assetRoot=${placeholder "lib"}"
  ];

  postInstall = ''
    mkdir -p $lib
    cp -v ./data/*.nix $lib
    wrapProgram $out/bin/morph --prefix PATH : ${lib.makeBinPath [ openssh ]};
  '';

  outputs = [
    "out"
    "lib"
  ];

  meta = with lib; {
    description = "NixOS host manager written in Golang";
    license = licenses.mit;
    homepage = "https://github.com/dbcdk/morph";
    maintainers = with maintainers; [
      adamt
      johanot
    ];
    mainProgram = "morph";
  };
}
