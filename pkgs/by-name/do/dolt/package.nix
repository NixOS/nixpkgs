{
  fetchFromGitHub,
  icu,
  lib,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "dolt";
  version = "2.1.9";

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AtCEygxUHlC73zWsBvYrdxLtSO2FtQd+NSthPnP2cvA=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorHash = "sha256-pBrTYPPPbDAKjok4ti8kjzxLPH4Xg1fqKQZx2QvEoVE=";
  proxyVendor = true;
  doCheck = false;

  buildInputs = [ icu ];

  meta = {
    description = "Relational database with version control and CLI a-la Git";
    mainProgram = "dolt";
    homepage = "https://github.com/dolthub/dolt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ miniharinn ];
  };
})
