{
  fetchFromGitHub,
  icu,
  lib,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "dolt";
  version = "1.84.1";

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gV5KqBo3Sk+oUER/VOgQVwnCucc4IZF/QmqZRTddI04=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorHash = "sha256-SRwxzkBNNVnGVDDhi3YR4ZXY1q2O78S2I+kp79Wh+50=";
  proxyVendor = true;
  doCheck = false;

  buildInputs = [ icu ];

  meta = {
    description = "Relational database with version control and CLI a-la Git";
    mainProgram = "dolt";
    homepage = "https://github.com/dolthub/dolt";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
