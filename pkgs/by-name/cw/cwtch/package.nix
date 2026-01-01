{
  buildGoModule,
  fetchgit,
<<<<<<< HEAD
  nix-update-script,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  lib,
}:
buildGoModule rec {
  pname = "libcwtch";
<<<<<<< HEAD
  version = "0.2.1";
=======
  version = "0.1.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # This Gitea instance has archive downloads disabled, so: fetchgit
  src = fetchgit {
    url = "https://git.openprivacy.ca/cwtch.im/autobindings.git";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Il4jADldw/tnRRiecCUrddKEvJ8WHvyT4s4zxSXqrnM=";
  };

  proxyVendor = true;
  vendorHash = "sha256-2Bs4cBQ+z5fqEvQ3xu31EngzdUZzZIl0sFsSjD60n2A=";
=======
    hash = "sha256-QHEaf3xm6SIHLnQamf0cUrKJ/A1v0iFaaGsMg33uIBs=";
  };

  vendorHash = "sha256-pnAdUFG1G0Bi/e9KNVX0WwloJy8xQ25YVFnGerRGy9A=";
  overrideModAttrs = (
    old: {
      preBuild = ''
        make lib.go
      '';
    }
  );
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Decentralized, privacy-preserving, multi-party messaging protocol";
    homepage = "https://cwtch.im/";
    changelog = "https://docs.cwtch.im/changelog";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.gmacon ];
  };
}
