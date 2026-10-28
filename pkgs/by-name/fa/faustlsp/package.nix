{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "faustlsp";
  version = "0-unstable-2025-10-29";

  src = fetchFromGitHub {
    owner = "grame-cncm";
    repo = "faustlsp";
    rev = "017e28bbf03cf632118a0a7e0d5dbe0c6a6ea52e";
    hash = "sha256-cidOJYQf58+zS9HlTJkzUy7zStHuX8bVhf4EkG9qR5k=";
  };

  vendorHash = "sha256-9qARh53TboBuTYp6kGxR53yjDkix0CKIt1VPYBmg0dY=";

  proxyVendor = true;

  doCheck = false;

  meta = {
    description = "Language Server Protocol (LSP) implementation for the Faust programming language";
    homepage = "https://github.com/grame-cncm/faustlsp";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ magnetophon ];
    mainProgram = "faustlsp";
    platforms = lib.platforms.all;
  };
})
