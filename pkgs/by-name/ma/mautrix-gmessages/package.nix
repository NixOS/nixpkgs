{
  lib,
  buildGoModule,
  fetchFromGitHub,
  olm,
  nix-update-script,
  testers,
  mautrix-gmessages,
  # This option enables the use of an experimental pure-Go implementation of the
  # Olm protocol instead of libolm for end-to-end encryption. Using goolm is not
  # recommended by the mautrix developers, but they are interested in people
  # trying it out in non-production-critical environments and reporting any
  # issues they run into.
  withGoolm ? false,
}:

buildGoModule (finalAttrs: {
  pname = "mautrix-gmessages";
  version = "26.11";
  tag = "v0.2611.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "gmessages";
    inherit (finalAttrs) tag;
    hash = "sha256-Z7Hv8OkQ1qbOLvQ11Vp9ssDXMT/V9Gva+S4eoDh7NgE=";
  };

  vendorHash = "sha256-y2RHc948wDe+LTi8J+Nc7v43kIWsMO9mFVkDSOFKImU=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.Tag=${finalAttrs.tag}"
  ];

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = mautrix-gmessages;
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "Matrix-Google Messages puppeting bridge";
    homepage = "https://github.com/mautrix/gmessages";
    changelog = "https://github.com/mautrix/gmessages/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      sumnerevans
      logn
    ];
    mainProgram = "mautrix-gmessages";
  };
})
