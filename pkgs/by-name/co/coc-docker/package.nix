{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-docker";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "josa42";
    repo = "coc-docker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-orSwQys+w2TKLau0gROyKh54vq7AwlVLsoU1EzALIDQ=";
  };

  npmDepsHash = "sha256-ow9viEFfyBUM2yDa63+pQCg6R5cAmznanqfI131fRxc=";

  meta = {
    description = "Docker language server extension using dockerfile-language-server-nodejs for coc.nvim";
    homepage = "https://github.com/josa42/coc-docker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
