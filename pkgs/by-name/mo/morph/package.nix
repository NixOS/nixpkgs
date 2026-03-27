{
  buildGoModule,
  fetchFromGitHub,
  lib,
  makeWrapper,
  openssh,
}:

buildGoModule (finalAttrs: {
  pname = "morph";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "dbcdk";
    repo = "morph";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IqWtVklzSq334cGgLx/13l329g391oDW50MZWyO6l08=";
  };

  vendorHash = "sha256-zQlMtbXgrH83zrcIoOuFhb2tYCeQ1pz4UQUvRIsLMCE=";

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-X main.version=${finalAttrs.version}"
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

  meta = {
    description = "NixOS host manager written in Golang";
    license = lib.licenses.mit;
    homepage = "https://github.com/dbcdk/morph";
    maintainers = with lib.maintainers; [
      adamt
      johanot
    ];
    mainProgram = "morph";
  };
})
