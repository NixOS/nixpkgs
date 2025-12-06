{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-mmproxy";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "kzemek";
    repo = "go-mmproxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9OGHK01ZE/Jc+KhSWpq2fOxXfVjpsya14sveKRtm7f8=";
  };

  vendorHash = null;

  # tests need network access
  doCheck = false;

  meta = {
    homepage = "https://github.com/kzemek/go-mmproxy";
    description = "A faster & stable implementation of mmproxy";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ daimond113 ];
    mainProgram = "go-mmproxy";
  };
})
