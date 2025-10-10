{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
  exiftool,
  zoxide,
}:
let
  version = "1.6.0";
  tag = "v${version}";
in
buildGoModule {
  pname = "superfile";
  inherit version;

  src = fetchFromGitHub {
    owner = "yorukot";
    repo = "superfile";
    inherit tag;
    hash = "sha256-JETdQ42vGPnpviCAR29BSdBTG+huWRr5syN5NysnAlo=";
  };

  vendorHash = "sha256-d2Yo8fWJ2fj7RJrnktljY6TkEPq6Tnbdh2BM4DIAr0E=";

  ldflags = [
    "-s"
    "-w"
  ];

  # TestLayout test does not support parallel testing
  enableParallelBuilding = false;

  nativeBuildInputs = [
    exiftool
    zoxide
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  preCheck = ''
    mkdir -p $HOME/.local/share/superfile
  '';

  checkFlags = [
    "-skip=^${
      lib.concatStringsSep "$|^" (
        [
          # Upstream notes that this could be flaky, and it consistently fails for me.
          "TestReturnDirElement/Sort_by_Date"

          # Tests fail with
          # ... `validations failed, error : file panel 1 error : invalid cursor : 0, element count : 0, layout info` ...
          "TestLayout"
        ]
        ++ lib.optionals stdenv.isDarwin [
          # Only failing on nix darwin. I suspect this is due to the way
          # darwin handles file permissions.
          "TestCompressSelectedFiles"
          "TestFileDelete/Move_to_trash"

          # Fails with directory cleanup
          "TestZoxide"
        ]
      )
    }$"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pretty fancy and modern terminal file manager";
    homepage = "https://github.com/yorukot/superfile";
    changelog = "https://github.com/yorukot/superfile/blob/${tag}/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      momeemt
      redyf
    ];
    mainProgram = "superfile";
  };
}
