{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-triton";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-triton";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V601v5FGRXA/pAMdRVHVVaH1glJHWkiX5Qtg3ysbbdw=";
  };

  vendorHash = "sha256-u3ufvGQOg3EEOXFiwZrssyISrH3MS63Cpg/o4QFZGKY=";

  meta = {
    description = "Packer plugin for Triton";
    homepage = "https://github.com/hashicorp/packer-plugin-triton";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
