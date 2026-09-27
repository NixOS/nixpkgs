{
  buildGoModule,
  fetchgit,
  nix-update-script,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "libcwtch";
  version = "1-hybrid";
  # This Gitea instance has archive downloads disabled, so: fetchgit
  src = fetchgit {
    url = "https://git.openprivacy.ca/cwtch.im/autobindings.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TNl2QMiLVulhdU3U9P6+RD9UMQXmJxSbv1KELZOWkaQ=";
  };

  proxyVendor = true;
  vendorHash = "sha256-O0KiZW5b1nMKqi5cCO/0N94/OYjSZH8+pZW1BPh7BRc=";

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '$(shell git describe --tags)' v${finalAttrs.version} \
      --replace-fail '$(shell git log -1 --format=%cd --date=format:%G-%m-%d-%H-%M)' 1980-01-01-00-00
  '';

  buildPhase = ''
    runHook preBuild
    make libCwtch.so
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D build/linux/libCwtch.h -t $out/include
    # * will match either "amd64" or "arm64" depending on the platform.
    install -D build/linux/*/libCwtch.so $out/lib/libCwtch.so
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Decentralized, privacy-preserving, multi-party messaging protocol";
    homepage = "https://cwtch.im/";
    changelog = "https://docs.cwtch.im/changelog";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.gmacon ];
  };
})
