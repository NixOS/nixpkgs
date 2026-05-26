{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "doc2go";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "abhinav";
    repo = "doc2go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-H9x4qMYHwox4ceWj1fx/YzD/j4n5+ncMXfoq94SPivo=";
  };
  vendorHash = "sha256-oV0XSNyR+1WapDvDCdGa67DDb1oDREIuHLu0vEu2/eI=";

  ldflags = [
    "-s"
    "-w"
    "-X main._version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];
  # integration is it's own module
  excludedPackages = [ "integration" ];

  checkFlags = [
    # needs to fetch additional go modules
    "-skip=TestFinder_ImportedPackage/Modules"
  ];

  preCheck = ''
    # run all tests
    unset subPackages
  '';

  meta = {
    homepage = "https://github.com/abhinav/doc2go";
    changelog = "https://github.com/abhinav/doc2go/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Your Go project's documentation, to-go";
    mainProgram = "doc2go";
    longDescription = ''
      doc2go is a command line tool that generates static HTML documentation
      from your Go code. It is a self-hosted static alternative to
      https://pkg.go.dev/ and https://godocs.io/.
    '';
    license = with lib.licenses; [
      # general project license
      asl20
      # internal/godoc/synopsis*.go adapted from golang source
      bsd3
    ];
    maintainers = with lib.maintainers; [ jk ];
  };
})
