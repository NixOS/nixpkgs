{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "mage";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "magefile";
    repo = "mage";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-aZPv3+F4VMiThjR0nFP+mKQLI9zKj2jaOawClROnT34=";
  };

  vendorHash = null;

  doCheck = false;

  ldflags = [
    "-X github.com/magefile/mage/mage.commitHash=v${finalAttrs.version}"
    "-X github.com/magefile/mage/mage.gitTag=v${finalAttrs.version}"
    "-X github.com/magefile/mage/mage.timestamp=1970-01-01T00:00:00Z"
  ];

  meta = {
    description = "Make/Rake-like Build Tool Using Go";
    mainProgram = "mage";
    homepage = "https://magefile.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ swdunlop ];
  };
})
