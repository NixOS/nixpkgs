{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  go,
  buf,
}:

buildGoModule rec {
  pname = "ignite-cli";
  version = "28.8.0";

  src = fetchFromGitHub {
    repo = "cli";
    owner = "ignite";
    rev = "v${version}";
    hash = "sha256-vLb3whalkOsP4CotTQjqNtHjHDCjTjZD7KSjKDWu2G0=";
  };

  vendorHash = "sha256-Efz2IzW/7NiaagzUpr37BGhiU8WcFvRIa61E91hwqGk=";

  nativeBuildInputs = [ makeWrapper ];

  # Many tests require access to either executables, state or networking
  doCheck = false;

  # Required for wrapProgram
  allowGoReference = true;

  # Required for commands like `ignite version`, `ignite network` and others
  postFixup = ''
    wrapProgram $out/bin/ignite --prefix PATH : ${
      lib.makeBinPath [
        go
        buf
      ]
    }
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
