{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  pandoc,
  go,
}:

buildGoModule rec {
  pname = "checkmake";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "mrtazz";
    repo = "checkmake";
    tag = version;
    hash = "sha256-Ql8XSQA/w7wT9GbmYOM2vG15GVqj9LxOGIu8Wqp9Wao=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.buildTime=1970-01-01T00:00:00Z"
    "-X=main.builder=nixpkgs"
    "-X=main.goversion=go${go.version}"
  ];

  postPatch = ''
    substituteInPlace man/man1/checkmake.1.md \
      --replace REPLACE_DATE 1970-01-01T00:00:00Z
  '';

  postBuild = ''
    pandoc man/man1/checkmake.1.md -st man -o man/man1/checkmake.1
  '';

  postInstall = ''
    installManPage man/man1/checkmake.1
  '';

  meta = with lib; {
    description = "Experimental tool for linting and checking Makefiles";
    mainProgram = "checkmake";
    homepage = "https://github.com/mrtazz/checkmake";
    changelog = "https://github.com/mrtazz/checkmake/releases/tag/${src.rev}";
    license = licenses.mit;
    longDescription = ''
      checkmake is an experimental tool for linting and checking
      Makefiles. It may not do what you want it to.
    '';
  };
}
