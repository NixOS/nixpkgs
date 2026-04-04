{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gen6dns";
  version = "1.3";

  src = fetchurl {
    url = "https://www.hznet.de/tools/gen6dns-${finalAttrs.version}.tar.gz";
    hash = "sha256-MhYfgzbGPmrhPx89EpObrEkxaII7uz4TbWXeEGF7Xws=";
  };

  nativeBuildInputs = [ installShellFiles ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  postInstall = ''
    installManPage gen6dns.1
  '';

  configureFlags = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
  ];

  makeFlags = [ "INSTALL_DIR=$(out)/bin" ];

  meta = {
    description = "Tool to generate static DNS records (AAAA and PTR) for hosts using Stateless Address Autoconfig (SLAAC)";
    homepage = "https://www.hznet.de/tools.html#gen6dns";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ majiir ];
    platforms = lib.platforms.unix;
  };
})
