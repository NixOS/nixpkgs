{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  nixosTests,
  git,
  bash,
}:

let
  version = "0.11.6";
in
buildGoModule {
  pname = "soft-serve";
  inherit version;

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "soft-serve";
    tag = "v${version}";
    hash = "sha256-oWZfhB14Yjj3/BKKhowKDKX5v4RvIwjHDCSFfnI+f54=";
  };

  vendorHash = "sha256-nsrfohr2b6zpbhWVRfOPydCpyUZzbR3YJz5viWGUwmQ=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    # Soft-serve generates git-hooks at run-time.
    # The scripts require git and bash inside the path.
    wrapProgram $out/bin/soft \
      --prefix PATH : "${
        lib.makeBinPath [
          git
          bash
        ]
      }"
  '';

  passthru.tests = nixosTests.soft-serve;

  meta = {
    description = "Tasty, self-hosted Git server for the command line";
    homepage = "https://github.com/charmbracelet/soft-serve";
    changelog = "https://github.com/charmbracelet/soft-serve/releases/tag/v${version}";
    mainProgram = "soft";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
