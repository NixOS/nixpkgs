{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-sh";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "josa42";
    repo = "coc-sh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Oq9/9/tSt+S8Oai3AgPKUzdccieSD4LudmQAN4ljHwI=";
  };

  patches = [
    # Ensure that all packages have `resolved` and `integrity` fields
    ./fix-package-lock.patch
  ];

  npmDepsHash = "sha256-N8bXRtTEKu9yuUnfv4oIokM74KWnqfTLVh5EvS0b1sw=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "bash-language-server for coc.nvim";
    homepage = "https://github.com/josa42/coc-sh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
