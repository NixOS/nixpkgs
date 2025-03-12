{
  buildGoModule,
  fetchgit,
  lib,
}:
buildGoModule rec {
  pname = "libcwtch";
  version = "0.1.5";
  # This Gitea instance has archive downloads disabled, so: fetchgit
  src = fetchgit {
    url = "https://git.openprivacy.ca/cwtch.im/autobindings.git";
    rev = "v${version}";
    hash = "sha256-SeMpL/ncDh4DgYYeikHiwRIF/RKsrOhRzPAePXglvqM=";
  };

  vendorHash = "sha256-ZgysF9ZYbuUdaxUiNAJ44JAeFKjBpOQ1DMXhO2RV7zc=";
  overrideModAttrs = (
    old: {
      preBuild = ''
        make lib.go
      '';
    }
  );

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '$(shell git describe --tags)' v${version} \
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

  meta = {
    description = "Decentralized, privacy-preserving, multi-party messaging protocol";
    homepage = "https://cwtch.im/";
    changelog = "https://docs.cwtch.im/changelog";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.gmacon ];
  };
}
