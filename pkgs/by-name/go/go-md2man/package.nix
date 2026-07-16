{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-md2man";
  version = "2.0.7";

  vendorHash = "sha256-aMLL/tmRLyGze3RSB9dKnoTv5ZK1eRtgV8fkajWEbU0=";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "cpuguy83";
    repo = "go-md2man";
    sha256 = "sha256-DKqGvdidl6J4lPhIk3okhU4k6MvtSr+hJ9huU/JTai0=";
  };

  meta = {
    description = "Go tool to convert markdown to man pages";
    mainProgram = "go-md2man";
    license = lib.licenses.mit;
    homepage = "https://github.com/cpuguy83/go-md2man";
    maintainers = [ ];
  };
})
