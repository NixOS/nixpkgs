{
  lib,
  buildGoModule,
  fetchFromGitHub,
  substitute,
  yarn-berry_4,
  callPackage,
  pkg-config,
  vips,
  makeWrapper,
  nixosTests,
}:
buildGoModule (finalAttrs: {
  pname = "koito";
  version = "0.3.2";
  src = fetchFromGitHub {
    owner = "gabehf";
    repo = "koito";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z0HeuPYQwkyKkt8K7PKUYseECz2p1C/6UO5sUSxopBQ=";

    # Remove when upstream updates to Yarn 4.15
    # https://github.com/gabehf/Koito/blob/main/client/package.json#L44
    postFetch = ''
      cd $out/client
      patch -p1 < ${
        (substitute {
          src = ./yarn-fix.patch;
          substitutions = [
            "--replace-fail"
            "YARN_LOCKFILE_VERSION_PLACEHOLDER"
            yarn-berry_4.lockfileVersion
          ];
        })
      }
    '';
  };
  __structuredAttrs = true;

  vendorHash = "sha256-W/+ByBlEPd4yIUD/E28q93fz6wYgvhwyBvJL8Fm1lNY=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [ vips ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/api $out/bin/.koito-wrapped

    mkdir -p $out/share
    cp -r --no-preserve=mode ${finalAttrs.passthru.client}/client $out/share/client

    makeWrapper $out/bin/.koito-wrapped $out/bin/koito \
      --run "cd $out/share"
  '';

  passthru = {
    client = callPackage ./client.nix {
      inherit (finalAttrs) src version;
      inherit yarn-berry_4;
    };

    tests = {
      inherit (nixosTests) koito;
    };

    updateScript = ./update.sh;
  };

  meta = {
    description = "Modern, themeable scrobbler that you can use with any program that scrobbles to a custom ListenBrainz URL";
    homepage = "https://koito.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iv-nn ];
    mainProgram = "koito";
  };
})
