{
  lib,
  buildGoModule,
  fetchFromGitHub,
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
    hash = "sha256-68+Z4Alzu+4v/PxU1IOboqZkF1pO+y6gswuO+HPS7dk=";
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
