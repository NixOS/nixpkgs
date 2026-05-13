{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "enumer";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "dmarkham";
    repo = "enumer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VowZcDNksa4ncydzdWyCDMcyEIujUmfVlf4SDEGPpVg=";
  };

  vendorHash = "sha256-3aiAvpNGW2FtMmpzKx/+dWJ3ZQG3BKJei8KcJMyDH20=";

  meta = {
    description = "Go tool to auto generate methods for enums";
    homepage = "https://github.com/dmarkham/enumer";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "enumer";
  };
})
