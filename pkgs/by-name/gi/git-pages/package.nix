{
  lib,
  stdenv,
  buildGoModule,
  fetchgit,
  nix-update-script,
  versionCheckHook,
  formats,
  coreutils,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "git-pages";
  version = "0.10.2";
  __structuredAttrs = true;

  # fetchFromCodeberg tries to download tar.gz from codeberg and times out frequently
  src = fetchgit {
    url = "https://codeberg.org/git-pages/git-pages.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-01X3Dc77Ge5njLIn8l24mq6MW3vp0P8SMo17R1P1g2E=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-VlagZykL6DhOXe55y98iweNk3VShzzhdXonHdQAETb8=";

  ldflags = [
    "-s"
    "-X main.versionOverride=${finalAttrs.src.tag}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru = {
    tests = lib.optionalAttrs (!stdenv.hostPlatform.isDarwin) {
      inherit (nixosTests) git-pages-modular;
    };
    updateScript = nix-update-script { };
    services.default = {
      imports = [
        (lib.modules.importApply ./service.nix { inherit formats coreutils; })
      ];
      git-pages.package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Scalable static site server for Git forges (like GitHub Pages or Netlify";
    homepage = "https://codeberg.org/git-pages/git-pages";
    changelog = "https://codeberg.org/git-pages/git-pages/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [
      drupol
      phanirithvij
    ];
    mainProgram = "git-pages";
  };
})
