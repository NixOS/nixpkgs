{ lib
, fetchFromGitHub
, buildGoModule
, makeWrapper
, go
, buf
}:

buildGoModule rec {
  pname = "ignite-cli";
  version = "28.1.1";

  src = fetchFromGitHub {
    repo = "cli";
    owner = "ignite";
    rev = "v${version}";
    hash = "sha256-8/YupS16j6+iMt09RO1RZrJNlxfmE27tOD+cYecKnbc=";
  };

  vendorHash = "sha256-GpRTOjrPF+GS0XfavG7GYG5FcHc8ELxzhminncV2Qgk=";

  nativeBuildInputs = [ makeWrapper ];

  # Many tests require access to either executables, state or networking
  doCheck = false;

  # Required for wrapProgram
  allowGoReference = true;

  # Required for commands like `ignite version`, `ignite network` and others
  postFixup = ''
    wrapProgram $out/bin/ignite --prefix PATH : ${lib.makeBinPath [ go buf ]}
  '';

  meta = with lib; {
    homepage = "https://ignite.com/";
    changelog = "https://github.com/ignite/cli/releases/tag/v${version}";
    description = "All-in-one platform to build, launch, and maintain any crypto application on a sovereign and secured blockchain";
    license = licenses.asl20;
    maintainers = with maintainers; [ kashw2 ];
    mainProgram = "ignite";
  };
}
