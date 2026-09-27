{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pod2mdoc";
  version = "0.2";

  src = fetchurl {
    url = "https://mdocml.bsd.lv/pod2mdoc/snapshots/pod2mdoc-${finalAttrs.version}.tgz";
    hash = "sha256-dPH+MfYdyHauClcD7N1zwjw4EPdtt9uQGCUh9OomsPw=";
  };

  # use compat_ohash instead of system ohash, which is BSD-specific
  postPatch = ''
    substituteInPlace Makefile --replace-fail "-DHAVE_OHASH=1" "-DHAVE_OHASH=0"
  '';

  nativeBuildInputs = [
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall
    installBin pod2mdoc
    installManPage pod2mdoc.1
    runHook postInstall
  '';

  enableParallelBuilding = true;
  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    homepage = "https://mandoc.bsd.lv/pod2mdoc/";
    description = "Converter from POD into mdoc";
    changelog = "https://mandoc.bsd.lv/pod2mdoc/ChangeLog";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ramkromberg ];
    mainProgram = "pod2mdoc";
  };
})
