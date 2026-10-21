{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cf-hero";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "musana";
    repo = "CF-Hero";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n0kcapHBz6Dap6KKJByCwBZmXmcO/aK88X78Yit6rx4=";
  };

  vendorHash = "sha256-Yf+iZ3UIpP9EtOWW1jh3h3zTFK1D7mcOh113Q4fbAhA=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool that uses multiple data sources to discover the origin IP addresses of Cloudflare-protected web applications";
    homepage = "https://github.com/musana/CF-Hero";
    changelog = "https://github.com/musana/CF-Hero/releases/tag/${finalAttrs.src.tag}";
    # No licensing details present, https://github.com/musana/CF-Hero/issues/16
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cf-hero";
  };
})
