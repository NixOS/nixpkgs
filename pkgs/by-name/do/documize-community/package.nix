{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go-bindata,
  go-bindata-assetfs,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "documize-community";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "documize";
    repo = "community";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Kv4BsFB08rkGRkePFIkjjuhK1TnLPS4m+PUlgKG5cTQ=";
  };

  vendorHash = null;

  doCheck = false;

  nativeBuildInputs = [
    go-bindata
    go-bindata-assetfs
  ];

  # This is really weird, but they've managed to screw up
  # their folder structure enough, you can only build by
  # literally cding into this folder.
  preBuild = "cd edition";

  subPackages = [ "." ];

  passthru.tests = { inherit (nixosTests) documize; };

  postInstall = ''
    mv $out/bin/edition $out/bin/documize
  '';

  meta = {
    description = "Open source Confluence alternative for internal & external docs built with Golang + EmberJS";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
    mainProgram = "documize";
    homepage = "https://www.documize.com/";
  };
})
