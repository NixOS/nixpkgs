{
  lib,
  buildGoModule,
  fetchurl,
  sqlite,
  installShellFiles,
  nixosTests,
}:
buildGoModule (finalAttrs: {
  pname = "honk";
  version = "1.5.2";

  src = fetchurl {
    url = "https://humungus.tedunangst.com/r/honk/d/honk-${finalAttrs.version}.tgz";
    hash = "sha256-7dIui+VMHn916yMdhqN6Pk2P/s0vvXzVKFsTZ5wp12A=";
  };
  vendorHash = null;

  buildInputs = [
    sqlite
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "." ];

  # This susbtitution is not mandatory. It is only existing to have something
  # working out of the box. This value can be overridden by the user, by
  # providing the `-viewdir` parameter in the command line.
  postPatch = ''
    substituteInPlace main.go --replace-fail \
      "var viewDir = \".\"" \
      "var viewDir = \"$out/share/honk\""
  '';

  postInstall = ''
    mkdir -p $out/share/honk
    mkdir -p $out/share/doc/honk

    mv docs/{,honk-}intro.1
    mv docs/{,honk-}hfcs.1
    mv docs/{,honk-}vim.3
    mv docs/{,honk-}activitypub.7

    installManPage docs/honk.1 docs/honk.3 docs/honk.5 docs/honk.8 \
      docs/honk-intro.1 docs/honk-hfcs.1 docs/honk-vim.3 docs/honk-activitypub.7
    mv docs/{*.html,*.txt,*.jpg,*.png} $out/share/doc/honk
    mv views $out/share/honk
  '';

  passthru.tests = {
    inherit (nixosTests) honk;
  };

  meta = {
    changelog = "https://humungus.tedunangst.com/r/honk/v/v${finalAttrs.version}/f/docs/changelog.txt";
    description = "ActivityPub server with minimal setup and support costs";
    homepage = "https://humungus.tedunangst.com/r/honk";
    license = lib.licenses.isc;
    mainProgram = "honk";
    maintainers = with lib.maintainers; [ huyngo ];
  };
})
